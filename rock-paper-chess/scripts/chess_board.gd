class_name ChessBoard
extends Node

@export var tilemap: TileMapLayer

const BOARD_SIZE := 8
const PT := preload("res://scripts/models/piece_types.gd")
const PieceScene: PackedScene = preload("res://scenes/Piece.tscn")
const PawnGraduation : PackedScene = preload("res://scenes/pawn_graduation.tscn")

@onready var white_player : Player = get_parent().get_node("WhitePlayer")
@onready var black_player : Player = get_parent().get_node("BlackPlayer")
@onready var current_player : Player

@onready var check : Sprite2D = get_node("Check")
@onready var white_sprite : Sprite2D = get_node("White's Turn")
@onready var black_sprite : Sprite2D = get_node("Black's Turn")

@onready var white_graveyard : Sprite2D = get_node("White Graveyard")
@onready var black_graveyard : Sprite2D = get_node("Black Graveyard")

@onready var rules_button : Button = get_node("Rules Button")
@onready var rules_sprite : Sprite2D = get_node("Rules")

@onready var stats : Label = get_node("stats")
@onready var white_winner : Sprite2D = get_tree().root.get_node("Main/WhiteWinner")
@onready var black_winner : Sprite2D = get_tree().root.get_node("Main/BlackWinner")

@onready var fade_transisiton = get_node("../FadeTransition")
@onready var fade_animation = get_node("../FadeTransition/AnimationPlayer")
@onready var fade_timer = get_node("../FadeTransition/FadeTimer")

var grid: Array = []

var selected_piece: Piece = null
var selected_pos: Vector2i
var hypothetical_damage : float = 0
var is_game_over : bool
var total_turns : int = 0

const CLASS_NAMES := {
	PT.Classes.PAWN:"Pawn",
	PT.Classes.KNIGHT:"Knight",
	PT.Classes.BISHOP:"Bishop",
	PT.Classes.ROOK:"Rook",
	PT.Classes.QUEEN:"Queen",
	PT.Classes.KING:"King",
}

# play the apprpriate sound effects when clicking the piece
func _play_piece_click_sfx(piece: Piece) -> void:
	match piece.piece_type:
		PT.Types.ROCK:
			Sfx.play("rock")
		PT.Types.PAPER:
			Sfx.play("paper")
		PT.Types.SCISSORS:
			Sfx.play("scissors")
		_:
			pass

# Signal for showing when the board's selected piece has changed
# Used for resetting visualizations and such
signal reset_piece_selection()

signal victory()

func _finished_drafting():
	var drafting := get_parent().get_node("Drafting")
	drafting.queue_free()
	# turn on camera for chessboard
	$Camera2D.enabled = true
	begin_chess_game()
	
func begin_chess_game():
	# Initialize the players
	white_player.color = Player.Player_Color.WHITE
	black_player.color = Player.Player_Color.BLACK
	
	_initialize_board()
	_initialize_piece_position()
	
	current_player = white_player
	white_sprite.visible = true
	fade_transisiton.show()
	fade_timer.start()
	fade_animation.play("fade_out")
	await fade_timer.timeout
	fade_transisiton.hide()
	
	rules_sprite.modulate.a = 0.0
	
	is_game_over = false

func _initialize_board():
	connect("victory", Callable(white_winner, "_finished_game"))
	connect("victory", Callable(black_winner, "_finished_game"))
	# 8x8 grid with null placeholders
	grid.resize(BOARD_SIZE)
	for i in range(BOARD_SIZE):
		grid[i] = []
		for j in range(BOARD_SIZE):
			grid[i].append(null)
			

func _initialize_piece_position():
	# Black pieces
	# Initialize Pawns
	for col in range(-4, 4):
		_set_piece(PieceTypes.Classes.PAWN, PieceTypes.Owner.BLACK, Vector2i(-3, col))

	# Other pieces
	_set_piece(PieceTypes.Classes.ROOK, PieceTypes.Owner.BLACK, Vector2i(-4, -4))
	_set_piece(PieceTypes.Classes.KNIGHT, PieceTypes.Owner.BLACK, Vector2i(-4, -3))
	_set_piece(PieceTypes.Classes.BISHOP, PieceTypes.Owner.BLACK, Vector2i(-4, -2))
	_set_piece(PieceTypes.Classes.QUEEN, PieceTypes.Owner.BLACK, Vector2i(-4, -1))
	_set_piece(PieceTypes.Classes.KING, PieceTypes.Owner.BLACK, Vector2i(-4, 0))
	_set_piece(PieceTypes.Classes.BISHOP, PieceTypes.Owner.BLACK, Vector2i(-4, 1))
	_set_piece(PieceTypes.Classes.KNIGHT, PieceTypes.Owner.BLACK, Vector2i(-4, 2))
	_set_piece(PieceTypes.Classes.ROOK, PieceTypes.Owner.BLACK, Vector2i(-4, 3))

	# White pieces
	# Initialize Pawns
	for col in range(-4, 4):
		_set_piece(PieceTypes.Classes.PAWN, PieceTypes.Owner.WHITE, Vector2i(2, col))

	# Other pieces
	_set_piece(PieceTypes.Classes.ROOK, PieceTypes.Owner.WHITE, Vector2i(3, -4))
	_set_piece(PieceTypes.Classes.KNIGHT, PieceTypes.Owner.WHITE, Vector2i(3, -3))
	_set_piece(PieceTypes.Classes.BISHOP, PieceTypes.Owner.WHITE, Vector2i(3, -2))
	_set_piece(PieceTypes.Classes.QUEEN, PieceTypes.Owner.WHITE, Vector2i(3, -1))
	_set_piece(PieceTypes.Classes.KING, PieceTypes.Owner.WHITE, Vector2i(3, 0))
	_set_piece(PieceTypes.Classes.BISHOP, PieceTypes.Owner.WHITE, Vector2i(3, 1))
	_set_piece(PieceTypes.Classes.KNIGHT, PieceTypes.Owner.WHITE, Vector2i(3, 2))
	_set_piece(PieceTypes.Classes.ROOK, PieceTypes.Owner.WHITE, Vector2i(3, 3))

# place pieces via setup functions
func _set_piece(piece_class: int, piece_owner: int, pos_on_board: Vector2i):
	var piece = PieceScene.instantiate()
	piece.set_board_reference(self)
	piece.piece_class = piece_class
	piece.piece_owner = piece_owner
	
	var player: Player
	if piece_owner==PT.Owner.WHITE:
		player = white_player
	else:
		player = black_player
	
	# get type based in class
	piece.piece_type = player.get_piece_type(CLASS_NAMES.get(piece_class))
	
	# set position
	grid[pos_on_board.x][pos_on_board.y] = piece
	#var idx = board_to_grid(pos_on_board)
	#grid[idx.x][idx.y] = piece
	add_child(piece)
	piece.position = board_to_world(pos_on_board)
	piece.location = pos_on_board
	# set the texture according to the player's data
	piece.set_texture()
	
	# Set the piece's stats
	piece.set_stats()
	
# Returns the centered position of a cell in the TileMap's local coordinate space.
func board_to_world(pos: Vector2i) -> Vector2:
	# reverse the pos for tilemap (col,row)
	return tilemap.map_to_local(Vector2i(pos.y, pos.x))
	
# return the board pos for tilemap
func world_to_board(pos: Vector2) -> Vector2i:
	var square : Vector2i = tilemap.local_to_map(tilemap.to_local(pos))
	return Vector2i(square.y, square.x)

# tansfer for grid [0,7] from [-4,3]
func board_to_grid(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.x + 4, pos.y + 4)

# Prompts pieces to load display logic upon being hovered.
# Only activates if a piece is not already selected via click
func on_piece_hovered(piece: Piece) -> void:
	if is_game_over:
		print("hi")
		return
	
	if selected_piece == null and piece.piece_owner == current_player.color:
		emit_signal("reset_piece_selection")
		piece.show_piece_options()
		piece.health_bar.show_damage_received(0)
	
	if selected_piece != null and piece.piece_owner != selected_piece.piece_owner:
		return

# manage the piece that selected by mouse (player)	
func on_piece_clicked(piece: Piece) -> void:
	if is_game_over:
		return
	
	if piece.piece_owner != current_player.color:
		return
	
	_play_piece_click_sfx(piece)
	emit_signal("reset_piece_selection")
	selected_piece = piece
	selected_pos = piece.location
	piece.show_piece_options()
	stats.text = str(PieceTypes.Classes.keys()[piece.piece_class]).capitalize() + \
	" stats:\nHealth: " + str(piece.health) + "\nDamage: " + str(piece.damage) \
	+ "\nType: " + str(PT.Types.keys()[piece.piece_type]).capitalize()
	
	for x in range(grid.size()):
		for y in range(grid[x].size()):
			var piece_at_space = grid[x][y]
			
			if (piece_at_space != null and piece_at_space.piece_owner != current_player.color):
				piece_at_space.health_bar.select_show = true
				piece_at_space.health_bar.show()
				
				hypothetical_damage = DamageEngine.damage_dealt(piece, piece_at_space)
				piece_at_space.health_bar.show_damage_received(hypothetical_damage / piece_at_space.max_health)


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# if the player hasn't select piece yet (e.g. click to background)
		if selected_piece == null:
			# skip
			return
		# get the real pos based on the cemera zoom effects
		# ref: https://forum.godotengine.org/t/confusion-about-screen-coordinates/97711/2
		var world_pos = get_viewport().canvas_transform.affine_inverse() * event.position
		var local_pos = tilemap.to_local(world_pos)
		var square: Vector2i = tilemap.local_to_map(local_pos)

		var target_pos = Vector2i(square.y, square.x)
		#print("target:", target_pos)
		
		if _try_move_to(target_pos):
			get_tree().get_root().set_input_as_handled()


func _try_move_to(target_pos: Vector2i) -> bool:
	if selected_piece == null:
		return false
	
	#if selected_piece.owner != current_player:
	#	return false
	
	# dev log: start pos is correct
	var start_pos = selected_piece.location

	var legal_moves = selected_piece.get_legal_moves(start_pos)
	if target_pos not in legal_moves:
		#print("not a valid move")
		return false
	
	_move_piece(start_pos, target_pos)
	
	# empty selection
	selected_piece = null
	return true


func _move_piece(start: Vector2i, target: Vector2i) -> void:
	var piece: Piece = grid[start.x][start.y]
	if piece == null:
		return
	
	var target_piece: Piece = grid[target.x][target.y]
	
	# Reset which pieces are clicked, glowing etc.
	selected_piece = null
	emit_signal("reset_piece_selection")
	
	var move_distance : float = (target - piece.location).length()
	var move_speed : float = 7.5
	var move_time : float = move_distance / move_speed
	
	animated_movement(piece, board_to_world(target), move_time)
	total_turns += 1
	# if the target pos has opponent's piece
	if target_piece != null:
		if target_piece.piece_owner != piece.piece_owner:
			if (current_player.color == Player.Player_Color.WHITE):
				white_player.total_damage_dealt += DamageEngine.damage_dealt(piece, target_piece)
			else:
				black_player.total_damage_dealt += DamageEngine.damage_dealt(piece, target_piece)
			if DamageEngine.challenge(piece, target_piece):
				target_piece.is_dead = true
				send_to_side(target_piece)
				current_player.num_of_lost_pieces += 1
				if target_piece.piece_class == PieceTypes.Classes.KING:
					_victory_screen()
			else:
				animated_movement(piece, board_to_world(piece.location), move_time)
				swap_turn()
				check_for_check()
				return
	
	# update grid status
	# start point -> no piece on it etc.
	grid[start.x][start.y] = null
	grid[target.x][target.y] = piece

	# update postion on board
	piece.location = target
	
	
	# update piece postion in world
	#piece.position = board_to_world(target)
	piece.has_moved = true
	
	# Check if castling occurred -> if so, update rook position as well
	if piece.piece_class == PieceTypes.Classes.KING && abs(target.y - start.y) == 2:
		# Castling occurred, get the rook
		var rook : Piece
		
		if target.y == -2:
			rook = grid[target.x][-4]
		else:
			rook = grid[target.x][3]
		# Move the rook
		grid[target.x][rook.location.y] = null
		grid[target.x][int(target.y / 2.0)] = rook
		
		var rook_location = Vector2i(target.x, int(target.y / 2.0))
		animated_movement(rook, board_to_world(rook_location), move_time)
		rook.has_moved = true
	
	# Check if the moved piece is a pawn that can graduate
	if piece.piece_class == PieceTypes.Classes.PAWN and ((piece.piece_owner == PieceTypes.Owner.WHITE and target.x == -4) or (piece.piece_owner == PieceTypes.Owner.BLACK and target.x == 3)):
		var pawn_graduation = PawnGraduation.instantiate()
		pawn_graduation.piece = piece
		add_child(pawn_graduation)
		await pawn_graduation.get_selection() # Wait for player to select upgrade
		
		# swap whose turn it is
	
	if (check_for_check()):
		get_tree().create_tween().tween_property(check, "modulate:a", 0.0, 0.1)
	
	swap_turn()
	
	check_for_check()

# Swaps the turn
func swap_turn() -> void:
	if current_player == white_player:
		get_tree().create_tween().tween_property(white_sprite, "modulate:a", 0.0, 0.1)
		
		white_sprite.visible = false
		black_sprite.visible = true
		black_sprite.modulate.a = 0.0
		
		get_tree().create_tween().tween_property(black_sprite, "modulate:a", 1.0, 0.1)
		
		current_player = black_player
		
	elif current_player == black_player:
		get_tree().create_tween().tween_property(black_sprite, "modulate:a", 0.0, 0.1)
		
		black_sprite.visible = false
		white_sprite.visible = true
		white_sprite.modulate.a = 0.0
		
		get_tree().create_tween().tween_property(white_sprite, "modulate:a", 1.0, 0.1)
		
		current_player = white_player

# This function checks to see whether the King can be attacked
func check_for_check() -> bool:
	for x in range(grid.size()):
		for y in range(grid[x].size()):
			var piece_at_space = grid[x][y]
			
			if (piece_at_space != null and piece_at_space.piece_owner != current_player.color):
				if (piece_at_space.can_attack_king(piece_at_space.location)):
					check.visible = true
					get_tree().create_tween().tween_property(check, "modulate:a", 1.0, 0.2)
					return true
					
	get_tree().create_tween().tween_property(check, "modulate:a", 0.0, 0.2)
	check.visible = false
	return false


func animated_movement(piece: Node2D, new_position: Vector2, time: float):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var original_scale = piece.scale
	var move_scale = original_scale * 1.2
	
	tween.tween_property(piece, "position", new_position, time)
	
	tween.parallel().tween_property(piece, "scale", move_scale, time * 0.5)
	tween.parallel().tween_property(piece, "scale", original_scale, time * 0.5).set_delay(time * 0.5)


func send_to_side(piece: Node2D):
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var new_scale = piece.scale * 0.5
	var time = 0.5
	
	var new_position : Vector2
	
	if (current_player == black_player):
		var width = white_graveyard.texture.get_width() * white_graveyard.scale.x
		var height = white_graveyard.texture.get_height() * white_graveyard.scale.y
		
		if (black_player.num_of_lost_pieces < 8):
			new_position = white_graveyard.position + Vector2(width * -(3.5/8.0), height * -0.25)
			new_position.x += (1.0/8.0) * width * black_player.num_of_lost_pieces
		else:
			new_position = white_graveyard.position + Vector2(width * -(3.5/8.0), height * 0.25)
			new_position.x += (1.0/8.0) * width * (black_player.num_of_lost_pieces - 8)
		
	else: 
		var width = black_graveyard.texture.get_width() * black_graveyard.scale.x
		var height = black_graveyard.texture.get_height() * black_graveyard.scale.y
		
		if (white_player.num_of_lost_pieces < 8):
			new_position = black_graveyard.position + Vector2(width * -(3.5/8.0), height * -0.25)
			new_position.x += (1.0/8.0) * width * white_player.num_of_lost_pieces
		else:
			new_position = black_graveyard.position + Vector2(width * -(3.5/8.0), height * 0.25)
			new_position.x += (1.0/8.0) * width * (white_player.num_of_lost_pieces - 8)
		
		
	
	tween.tween_property(piece, "position", new_position, time)
	
	tween.parallel().tween_property(piece, "scale", new_scale, time)
	
	return tween


func _on_rules_button_pressed() -> void:
	var tween = get_tree().create_tween()
	var parent = rules_sprite.get_parent()
	if rules_sprite.visible:
		tween.tween_property(rules_sprite, "modulate:a", 0.0, 0.25)
		await tween.finished
		rules_sprite.visible = false
	else:
		rules_sprite.visible = true
		parent.remove_child(rules_sprite)
		parent.add_child(rules_sprite)
		get_tree().create_tween().tween_property(rules_sprite, "modulate:a", 1.0, 0.25)


func _victory_screen():
	Sfx.pause_bgm()
	fade_transisiton.show()
	fade_timer.start()
	fade_animation.play("fade_in")
	await fade_timer.timeout
	is_game_over = true
	emit_signal("victory", white_player.total_damage_dealt, black_player.total_damage_dealt, \
	white_player.num_of_lost_pieces, black_player.num_of_lost_pieces, total_turns)
	if current_player == black_player:
		white_winner.visible = true
		fade_animation.play("fade_out")
		await fade_timer.timeout
		fade_transisiton.hide()
		Sfx.play("victory")
	else:
		black_winner.visible = true
		fade_animation.play("fade_out")
		await fade_timer.timeout
		fade_transisiton.hide()
		Sfx.play("victory")
