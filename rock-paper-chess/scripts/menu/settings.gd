extends Button

func _ready():
	var button = $"."
	button.pressed.connect(_settings_button_pressed)

func _settings_button_pressed():
	$"../SettingsPopup".visible = true
