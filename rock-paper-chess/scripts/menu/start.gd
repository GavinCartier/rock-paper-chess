extends Button

# This will need to swap to the draft screen, but for now it goes straight to the chessboard.
@onready var chess_board = get_node("../../../ChessBoard")
@onready var menu = get_node("../..")
@onready var drafting = get_node("../../../Drafting")
@onready var cutscene = get_node("../../../Cutscene")
@onready var cam : Camera2D = get_node("../../../Camera2D")
@onready var fade_transisiton = get_node("../../../FadeTransition")
@onready var fade_timer = get_node("../../../FadeTransition/FadeTimer")

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	fade_transisiton.fade_in()
	await fade_timer.timeout
	menu.set_visible(false)
	drafting.set_visible(false)
	cutscene.set_visible(true)
	fade_transisiton.fade_out()
	await fade_timer.timeout
	
	await cutscene.run()
	fade_transisiton.fade_in()
	await fade_timer.timeout
	cutscene.queue_free()
	
	drafting.set_visible(true)
	fade_transisiton.fade_out()
	await fade_timer.timeout
