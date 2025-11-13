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

var location : Vector2i

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

	
func set_texture():
	# Get attributes for player's pieces
	var ptype = TYPE_NAMES.get(piece_type)
	var pname = CLASS_NAMES.get(piece_class)
	var player_name = OWNER_NAMES.get(piece_owner)
	
	# Get the texture assets
	var sprite_filepath = "res://assets/Placeholder Assets/" + ptype + "/" + player_name + "/" + ptype + " " + pname + " " + player_name + ".png"
	sprite.texture = load(sprite_filepath)
	
# Function to receive damage
func receive_damage(_damage : float) -> void:
	pass
