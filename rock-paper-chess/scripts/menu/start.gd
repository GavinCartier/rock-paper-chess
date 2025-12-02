extends Button

# This will need to swap to the draft screen, but for now it goes straight to the chessboard.
@onready var chess_board = get_node("../../../ChessBoard")
@onready var menu = get_node("../..")
@onready var drafting = get_node("../../../Drafting")
@onready var cutscene = get_node("../../../Cutscene")
@onready var cam : Camera2D = get_node("../../../Camera2D")

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	menu.set_visible(false)
	drafting.set_visible(false)
	cutscene.set_visible(true)
	
	await cutscene.play()
	drafting.set_visible(true)
	cam.zoom = Vector2(0.5, 0.5)
