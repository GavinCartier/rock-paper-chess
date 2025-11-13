class_name ChessBoard
extends Node

const BOARD_SIZE := 8
@export var tilemap: TileMapLayer
const PT := preload("res://scripts/models/piece_types.gd")

@onready var white_player : Player = get_parent().get_node("WhitePlayer")
@onready var black_player : Player = get_parent().get_node("BlackPlayer")
var grid: Array = []

const PieceScene: PackedScene = preload("res://scenes/Piece.tscn")

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
	add_child(piece)
	piece.position = board_to_world(pos_on_board)
	# set the texture according to the player's data
	piece.set_texture()
	
# Returns the centered position of a cell in the TileMap's local coordinate space.
func board_to_world(pos: Vector2i) -> Vector2:
	# reverse the pos for tilemap (col,row)
	return tilemap.map_to_local(Vector2i(pos.y, pos.x))
