class_name ChessBoard
extends Node

@export var tilemap: TileMapLayer

const BOARD_SIZE := 8
const PT := preload("res://scripts/models/piece_types.gd")
const PieceScene: PackedScene = preload("res://scenes/Piece.tscn")

@onready var white_player : Player = get_parent().get_node("WhitePlayer")
@onready var black_player : Player = get_parent().get_node("BlackPlayer")

var grid: Array = []

var selected_piece: Piece = null
var selected_pos: Vector2i


const CLASS_NAMES := {
	PT.Classes.PAWN:"Pawn",
	PT.Classes.KNIGHT:"Knight",
	PT.Classes.BISHOP:"Bishop",
	PT.Classes.ROOK:"Rook",
	PT.Classes.QUEEN:"Queen",
	PT.Classes.KING:"King",
}
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

func _initialize_board():
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
	
# manage the piece that selected by mouse (player)	
func on_piece_clicked(piece: Piece) -> void:
	# first time select piece
	if selected_piece == null:
		# set the current one as selected
		selected_piece = piece
		selected_pos = piece.location
		return
	
	# update the piece if the player select another one
	if piece.piece_owner == selected_piece.piece_owner:
		selected_piece = piece
		selected_pos = piece.location
		return

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
		print("target:", target_pos)
		
		_try_move_to(target_pos)
		
func _try_move_to(target_pos: Vector2i) -> void:
	if selected_piece == null:
		return
	# dev log: start pos is correct
	var start_pos = selected_piece.location
	# target should be (1,-3)
	print("start:", start_pos, " target:", target_pos)
	
	var possible_moves: Array = PT.get_possible_moves(
		selected_piece.piece_class,
		selected_piece.piece_owner,
		Vector2(start_pos.x, start_pos.y),
		self)
	var offset = Vector2(target_pos.x - start_pos.x, target_pos.y - start_pos.y)
	print("offset:", offset)
	print("possible_moves:", possible_moves)
	
	var valid_move :bool = false
	# check whether it is a valid movement
	for i in possible_moves:
		if i == offset:
			valid_move = true
			break
	
	if not valid_move:
		print("not a valid move")
		return
	
	_move_piece(start_pos, target_pos)
	
	# empty selection
	selected_piece = null
	
func _move_piece(start: Vector2i, target: Vector2i) -> void:
	var piece: Piece = grid[start.x][start.y]
	if piece == null:
		return
	
	var target_piece: Piece = grid[target.x][target.y]
	
	# if the target pos has opponent's piece
	if target_piece != null:
		if target_piece.piece_owner != piece.piece_owner:
			# waiting for challenge fucntion
			# right now just delete for dev
			target_piece.queue_free()
	
	# update grid status
	# start point -> no piece on it etc.
	grid[start.x][start.y] = null
	grid[target.x][target.y] = piece
	
	# update postion on board
	piece.location = target
	
	# update piece postion in world
	piece.position = board_to_world(target)
