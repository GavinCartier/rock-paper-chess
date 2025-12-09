extends ColorRect

@onready var fade_transisiton = get_node(".")
@onready var fade_animation = get_node("AnimationPlayer")
@onready var fade_timer = get_node("FadeTimer")

func fade_in() -> void:
	_play_animation("fade_in")

func fade_out() -> void:
	_play_animation("fade_out")
	
func _play_animation(string : String) -> void:
	fade_transisiton.show()
	fade_timer.start()
	fade_animation.play(string)
	await fade_timer.timeout
	fade_transisiton.hide()
