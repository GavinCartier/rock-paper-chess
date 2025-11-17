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
var is_clicked : bool = false

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
	health_bar.hide()


func set_texture():
	# Get attributes for player's pieces
	var ptype = TYPE_NAMES.get(piece_type)
	var pname = CLASS_NAMES.get(piece_class)
	var player_name = OWNER_NAMES.get(piece_owner)
	
	# Get the texture assets
	var sprite_filepath = "res://assets/Placeholder Assets/" + ptype + "/" + player_name + "/" + ptype + " " + pname + " " + player_name + ".png"
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
	var possible_moves = PieceTypes.get_possible_moves(piece_class, piece_owner, location, board)
	var legal_moves : Array
	for move in possible_moves:
		var potential_move = move + current_position
		
		var move_out_of_bounds = (potential_move.x > 3 or potential_move.x < -4) or (potential_move.y > 3 or potential_move.y < -4)
		
		if not move_out_of_bounds:
			var piece_at_space = board.grid[potential_move.x][potential_move.y]
			
			if piece_at_space == null or piece_at_space.piece_owner != piece_owner:
				legal_moves.append(potential_move)
	
	return legal_moves

func _on_mouse_entered():
	health_bar.show()
	if not is_clicked:
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
			
			glow.texture = load(sprite_filepath)
			
			glow.scale = Vector2(0.5, 0.5)
			
			glow.position = board_to_world(move)
			
			# I know I'm using the location.y to adjust position.x and vice versa
			# But it works, no clue why lmao
			# I think it's because the tilemap (x,y) is opposite to world pos
			# which means tilemap is actually (y,x) to the world axis
			#glow.position.x -= 256 * location.y + 128
			#glow.position.y -= 256 * location.x + 128
			
			glow_sprites.append(glow)


func _on_mouse_exited():
	health_bar.hide()
	if not is_clicked:
		remove_glows()


func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if board != null:
			board.on_piece_clicked(self)
			
# Returns the centered position of a cell in the TileMap's local coordinate space.
func board_to_world(pos: Vector2i) -> Vector2:
	# reverse the pos for tilemap (col,row)
	return tilemap.map_to_local(Vector2i(pos.y, pos.x))


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


func remove_glows() -> void:
	for glow in glow_sprites:
		glow.queue_free()
	
	is_clicked = false
	glow_sprites.clear()
