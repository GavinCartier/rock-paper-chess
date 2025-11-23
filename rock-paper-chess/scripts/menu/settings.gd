extends Button

@onready var Settings = $"../../../SettingsPopup"
func _ready():
	var button = $"."
	button.pressed.connect(_button_pressed)

func _button_pressed():
	Settings.visible = true
