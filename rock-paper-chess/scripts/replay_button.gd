extends Button

func _ready():
	var button = $"."
	button.pressed.connect(_replay_button_pressed)

func _replay_button_pressed():
	get_tree().reload_current_scene()
