extends Button

@onready var fade_transisiton = get_node("../../FadeTransition")
@onready var fade_animation = get_node("../../FadeTransition/AnimationPlayer")
@onready var fade_timer = get_node("../../FadeTransition/FadeTimer")

func _ready():
	var button = $"."
	button.pressed.connect(_replay_button_pressed)

func _replay_button_pressed():
	Sfx.play("woosh")
	fade_transisiton.fade_in()
	await fade_timer.timeout
	Sfx.resume_bgm()
	get_tree().reload_current_scene()
