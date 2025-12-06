extends Node

var offsets: Dictionary[String, float] = {
	"dice": 0.45,   # skip first 0.45 seconds
	"clap": 0.55,
	"lasso": 0.10,
	"paper": 0.54,
	"woosh": 0.08
}

const BGM_BUS_NAME: String = "bgm"

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

		# If an offset exists for this sfx, apply it
		if offsets.has(sfx_name):
			var offset: float = offsets[sfx_name]
			if offset > 0.0:
				player.seek(offset)
				

func pause_bgm() -> void:
	var bus_idx := AudioServer.get_bus_index(BG_BUS_NAME)
	if bus_idx >= 0:
		AudioServer.set_bus_mute(bus_idx, true)

func resume_bgm() -> void:
	var bus_idx := AudioServer.get_bus_index(BG_BUS_NAME)
	if bus_idx >= 0:
		AudioServer.set_bus_mute(bus_idx, false)
