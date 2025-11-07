extends RefCounted
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

# Function to receive damage
func receive_damage(damage : float) -> void:
	pass
