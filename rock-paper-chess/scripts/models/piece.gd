extends Node2D
class_name Piece

const PT := preload("res://scripts/models/piece_types.gd")

'''
This class defines the actual pieces and their data-based representations
They use the enums defined in PieceTypes to define their class, type,
and owner.
They also keep track of their own location.
'''

var piece_class : int  # PT.Classes
var piece_type :  int  # PT.Types
var piece_owner : int  # PT.Owner

# Combat stats
var damage : float
var health : float
var max_health : float

var location : Vector2i

var is_dead : bool = false
var has_moved : bool # Whether this piece has moved or not (used for castling)

# convert to string for searching file path
const CLASS_NAMES := {
	PT.Classes.PAWN:"Pawn",
	PT.Classes.KNIGHT:"Knight",
	PT.Classes.BISHOP:"Bishop",
	PT.Classes.ROOK:"Rook",
	PT.Classes.QUEEN:"Queen",
	PT.Classes.KING:"King",
}

const OWNER_NAMES := {
	PT.Owner.WHITE:"White",
	PT.Owner.BLACK:"Black",
}

const TYPE_NAMES := {
	PT.Types.ROCK:"Rock",
	PT.Types.PAPER:"Paper",
	PT.Types.SCISSORS:"Scissors",
}

@onready var sprite: Sprite2D = $PieceSprite
@onready var area = $Area2D
@onready var tilemap: TileMapLayer
@onready var health_bar: HealthBar = $HealthBar

var glow_sprites : Array = []
var board : ChessBoard

func _ready():
	tilemap = get_parent().get_node("TileMapLayer")
	area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	area.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	area.connect("input_event", Callable(self, "_on_area_input"))
	
	board.reset_piece_selection.connect(_on_reset_piece_selection)
	health_bar.hide()
	
	has_moved = false


func set_texture():
	# Get attributes for player's pieces
	var ptype = TYPE_NAMES.get(piece_type)
	var pname = CLASS_NAMES.get(piece_class)
	var player_name = OWNER_NAMES.get(piece_owner)
	
	# Get the texture assets
	var sprite_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " " + pname + " " + player_name + ".PNG"
	sprite.texture = load(sprite_filepath)

# Set the stats for this piece based on its type
func set_stats():
	damage = PT.damage_stats.get(piece_class)
	max_health = PT.health_stats.get(piece_class)
	health = max_health
	

# Function to receive damage
func receive_damage(damage_received : float) -> void:
	health = max(0.0, health - damage_received)
	health_bar.update_health(health / max_health)


func set_board_reference(cb : ChessBoard):
	board = cb


func get_legal_moves(current_position : Vector2i) -> Array:
	if is_dead:
		return []
		
	var possible_moves = PieceTypes.get_possible_moves(piece_class, piece_owner, location, board)
	var legal_moves : Array = []
	for move in possible_moves:
		var potential_move = move + current_position
		
		var move_out_of_bounds = (potential_move.x > 3 or potential_move.x < -4) or (potential_move.y > 3 or potential_move.y < -4)
		
		if not move_out_of_bounds:
			var piece_at_space = board.grid[potential_move.x][potential_move.y]
			
			if piece_at_space == null or piece_at_space.piece_owner != piece_owner:
				legal_moves.append(potential_move)
	
	return legal_moves


func can_attack_king(current_position : Vector2i) -> bool:
	if is_dead:
		return false
		
	var legal_moves := get_legal_moves(current_position)
	
	for move in legal_moves:
		var piece_at_space = board.grid[move.x][move.y]
		
		if (piece_at_space != null):
			if (piece_at_space.piece_owner != piece_owner and piece_at_space.piece_class == PieceTypes.Classes.KING):
				return true
	
	return false


func _on_mouse_entered():
	if is_dead or board.is_game_over:
		return
	
	self.scale = Vector2(1.0, 1.0)
		
	health_bar.show()
	board.on_piece_hovered(self)


func _on_mouse_exited():
	if is_dead:
		return
		
	health_bar.hide()
	if not board.selected_piece:
		_on_reset_piece_selection()

func _on_area_input(_viewport, event, _shape_idx):
	if is_dead:
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if board != null:
			board.on_piece_clicked(self)
			
# Returns the centered position of a cell in the TileMap's local coordinate space.
func board_to_world(pos: Vector2i) -> Vector2:
	# reverse the pos for tilemap (col,row)
	return tilemap.map_to_local(Vector2i(pos.y, pos.x))

# This is a function received from a signal in board. Resets selection options
func _on_reset_piece_selection() -> void:
	remove_glows()
	health_bar.select_show = false
	health_bar.hide()

# Show all piece options (health bars and targets)
func show_piece_options() -> void:
	if is_dead:
		return
		
	health_bar.select_show = true
	health_bar.show()
	show_glows()

func check_type_matchup(enemy: Piece) -> int:
	match enemy.piece_type:
		PieceTypes.Types.ROCK:
			match piece_type:
				PieceTypes.Types.ROCK:
					return 0 # neutral
				PieceTypes.Types.PAPER:
					return -1 # disadvantage
				PieceTypes.Types.SCISSORS:
					return 1 # advantage
				_:
					return 0 # if something weird happens just treat it as neutral
					
		PieceTypes.Types.PAPER:
			match piece_type:
				PieceTypes.Types.PAPER:
					return 0 # neutral
				PieceTypes.Types.SCISSORS:
					return -1 # disadvantage
				PieceTypes.Types.ROCK:
					return 1 # advantage
				_:
					return 0 # if something weird happens just treat it as neutral
					
		PieceTypes.Types.SCISSORS:
			match piece_type:
				PieceTypes.Types.SCISSORS:
					return 0 # neutral
				PieceTypes.Types.ROCK:
					return -1 # disadvantage
				PieceTypes.Types.PAPER:
					return 1 # advantage
				_:
					return 0 # if something weird happens just treat it as neutral
		_:
			return 0 # if something weird happens just treat it as neutral

func delete() -> void:
	remove_glows()
	self.queue_free()

# Show the glowing tiles indicating moves, as well as the damage indicators for piece targets
func show_glows() -> void:
	if is_dead:
		return
		
	var legal_moves = get_legal_moves(location)
		
	for move in legal_moves:
		var glow := Sprite2D.new()
		board.add_child(glow)
		
		var sprite_filepath : String
		var piece_at_space = board.grid[move.x][move.y]
		if piece_at_space == null:
			sprite_filepath = "res://assets/tile glow/white glow.png"
		else:
			var advantage = check_type_matchup(piece_at_space)
			match advantage:
				-1:
					sprite_filepath = "res://assets/tile glow/green glow.png"
				0:
					sprite_filepath = "res://assets/tile glow/yellow glow.png"
				1:
					sprite_filepath = "res://assets/tile glow/red glow.png"
				
			# Show the health that the piece would have afterward
			piece_at_space.health_bar.select_show = true
			piece_at_space.health_bar.show()
			var hypothetical_damage : float = DamageEngine.damage_dealt(self, piece_at_space)
			piece_at_space.health_bar.show_damage_received(hypothetical_damage / piece_at_space.max_health)
		
		glow.texture = load(sprite_filepath)
		
		glow.scale = Vector2(0.5, 0.5)
		
		glow.position = board_to_world(move)
		
		glow_sprites.append(glow)

# Remove all glowing squares and damage indicators
func remove_glows() -> void:
	for move in get_legal_moves(location):
		var piece_at_space = board.grid[move.x][move.y]
		if piece_at_space != null:
			piece_at_space.health_bar.select_show = false
			piece_at_space.health_bar.hide_damage_received()
			piece_at_space.health_bar.hide()
	
	for glow in glow_sprites:
		glow.queue_free()
	
	glow_sprites.clear()
