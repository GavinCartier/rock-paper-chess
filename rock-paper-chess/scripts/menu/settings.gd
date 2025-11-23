extends Button

func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Sfx.play("woosh")
	print("Clicked")
