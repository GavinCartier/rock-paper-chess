extends Node

const PieceType := preload("res://scripts/models/piece_types.gd")

@onready var knight_area : Area2D = $Knight/KnightArea
@onready var bishop_area : Area2D = $Bishop/BishopArea
@onready var rook_area : Area2D = $Rook/RookArea
@onready var queen_area : Area2D = $Queen/QueenArea

@onready var knight_sprite : Sprite2D = $Knight/KnightSprite
@onready var bishop_sprite : Sprite2D = $Bishop/BishopSprite
@onready var rook_sprite : Sprite2D = $Rook/RookSprite
@onready var queen_sprite : Sprite2D = $Queen/QueenSprite

var piece : Piece
var piece_selection : PieceType.Classes = PieceType.Classes.PAWN

func _ready():
	knight_area.connect("input_event", Callable(self, "_on_knight_area_input"))
	bishop_area.connect("input_event", Callable(self, "_on_bishop_area_input"))
	rook_area.connect("input_event", Callable(self, "_on_rook_area_input"))
	queen_area.connect("input_event", Callable(self, "_on_queen_area_input"))

func get_selection():
	if piece.board.is_game_over:
		return
	# Get the names of the piece types & owners
	var ptype = piece.TYPE_NAMES.get(piece.piece_type)
	var player_name = piece.OWNER_NAMES.get(piece.piece_owner)
	
	# Display correct selection options
	# Get the filepaths
	var knight_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " Knight " + player_name + ".PNG"
	var bishop_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " Bishop " + player_name + ".PNG"
	var rook_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " Rook " + player_name + ".PNG"
	var queen_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " Queen " + player_name + ".PNG"
	
	# Set the sprites
	knight_sprite.texture = load(knight_filepath)
	bishop_sprite.texture = load(bishop_filepath)
	rook_sprite.texture = load(rook_filepath)
	queen_sprite.texture = load(queen_filepath)
	
	# Poll for selection
	while piece_selection == PieceType.Classes.PAWN:
		await get_tree().process_frame
	
	# Set the piece to its new properties
	piece.piece_class = piece_selection
	piece.set_texture()
	piece.set_stats()
	
	queue_free() # Delete itself

func _on_knight_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		piece_selection = PieceType.Classes.KNIGHT

func _on_bishop_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		piece_selection = PieceType.Classes.BISHOP

func _on_rook_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:	
		piece_selection = PieceType.Classes.ROOK

func _on_queen_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		piece_selection = PieceType.Classes.QUEEN
