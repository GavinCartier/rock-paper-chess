extends Button

# This will need to swap to the draft screen, but for now it goes straight to the chessboard.
var chess_board = preload("res://scenes/ChessBoard.tscn")
var menu = preload("res://scenes/Menu.tscn")

func _ready():
	var button = $"."
	button.pressed.connect(_start_button_pressed)

func _start_button_pressed():
	visible = false
	$"../SettingsPopup".visible = false
	$"..".visible = false
