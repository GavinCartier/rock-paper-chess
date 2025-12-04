class_name ExitButton
extends Button

@onready var fade_transisiton = get_node("../../../FadeTransition")
@onready var fade_animation = get_node("../../../FadeTransition/AnimationPlayer")
@onready var fade_timer = get_node("../../../FadeTransition/FadeTimer")

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	fade_transisiton.show()
	fade_timer.start()
	fade_animation.play("fade_in")
	await fade_timer.timeout
	get_tree().quit()
	
