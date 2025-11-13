class_name ChessBoard
extends Node

const BOARD_SIZE := 8
var grid: Array = []

func _ready():
	_initialize_board()

func _initialize_board():
	# 8x8 grid with null placeholders
	grid.resize(BOARD_SIZE)
	for i in range(BOARD_SIZE):
		grid[i] = []
		for j in range(BOARD_SIZE):
			grid[i].append(null)

	# You can then place pieces manually or via setup functions
	# Example:
	# grid[6][0] = preload("res://Piece.tscn").instantiate()
	# grid[6][0].piece_class = PieceTypes.Classes.PAWN
	# grid[6][0].owner = PieceTypes.Owner.WHITE
