extends Node

func _get_audio_root() -> Node:
	return get_node_or_null("/root/Main/Audio")

func play(sfx_name: String) -> void:
	var audio_root := _get_audio_root()
	if audio_root == null:
		return
	var player := audio_root.get_node_or_null(sfx_name)
	if player and player is AudioStreamPlayer:
		player.stop()
		player.play()
