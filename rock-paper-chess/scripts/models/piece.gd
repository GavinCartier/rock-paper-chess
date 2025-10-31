extends Node
class_name Piece

'''
This class defines the actual pieces and their data-based representations
They use the enums defined in PieceTypes to define their class, type,
and owner.
They also keep track of their own location.
'''

var piece_class : PieceTypes.Classes
var piece_type : PieceTypes.Types
var piece_owner : PieceTypes.Owner

var location : Vector2i
