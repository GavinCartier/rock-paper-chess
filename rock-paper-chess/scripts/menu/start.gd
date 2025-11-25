extends Button

# This will need to swap to the draft screen, but for now it goes straight to the chessboard.
@onready var chess_board = get_node("../../ChessBoard")
@onready var menu = get_node("../..")
@onready var drafting = get_node("../../../Drafting")

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	menu.set_visible(false)
