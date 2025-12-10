class_name ExitButton
extends Button

@onready var fade_transisiton = get_node("../../../FadeTransition")
@onready var fade_timer = get_node("../../../FadeTransition/FadeTimer")

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	fade_transisiton.fade_in()
	await fade_timer.timeout
	get_tree().quit()
