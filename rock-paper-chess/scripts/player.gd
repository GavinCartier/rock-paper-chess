class_name Player
extends Node

enum Player_Color {WHITE, BLACK}

var color : int

var pawn : Piece
var rook : Piece
var knight : Piece
var bishop : Piece
var queen : Piece
var king : Piece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pawn = Piece.new()
	pawn.piece_class = PieceTypes.Classes.PAWN
	pawn.piece_owner = color
	
	rook = Piece.new()
	rook.piece_class = PieceTypes.Classes.ROOK
	rook.piece_owner = color
	
	knight = Piece.new()
	knight.piece_class = PieceTypes.Classes.KNIGHT
	knight.piece_owner = color
	
	bishop = Piece.new()
	bishop.piece_class = PieceTypes.Classes.BISHOP
	bishop.piece_owner = color
	
	queen = Piece.new()
	queen.piece_class = PieceTypes.Classes.QUEEN
	queen.piece_owner = color
	
	king = Piece.new()
	king.piece_class = PieceTypes.Classes.KING
	king.piece_owner = color
