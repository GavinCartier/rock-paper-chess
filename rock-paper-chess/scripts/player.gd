class_name Player
extends Node

enum Player_Color {WHITE, BLACK}

var color : Player_Color

var pawn : Piece
var rook : Piece
var knight : Piece
var bishop : Piece
var queen : Piece
var king : Piece

var initialized : bool = false

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
	
	initialized = true


func get_piece_type(piece_name: String) -> PieceTypes.Types:
	match piece_name:
		"Pawn":
			return pawn.piece_type as PieceTypes.Types
		"Rook":
			return rook.piece_type as PieceTypes.Types
		"Knight":
			return knight.piece_type as PieceTypes.Types
		"Bishop":
			return bishop.piece_type as PieceTypes.Types
		"Queen":
			return queen.piece_type as PieceTypes.Types
		"King":
			return king.piece_type as PieceTypes.Types
		_:
			return PieceTypes.Types.NONE


func set_piece_type(piece_name: String, type_text: String) -> void:
	var type_enum: int
	match type_text:
		"Rock":
			type_enum = PieceTypes.Types.ROCK
		"Paper":
			type_enum = PieceTypes.Types.PAPER
		"Scissors":
			type_enum = PieceTypes.Types.SCISSORS
		_:
			push_warning("Unknown type: %s" % type_text)
			return

	match piece_name:
		"Pawn":
			pawn.piece_type = type_enum
		"Rook":
			rook.piece_type = type_enum
		"Knight":
			knight.piece_type = type_enum
		"Bishop":
			bishop.piece_type = type_enum
		"Queen":
			queen.piece_type = type_enum
		"King":
			king.piece_type = type_enum
		_:
			push_warning("Unknown piece name: %s" % piece_name)
