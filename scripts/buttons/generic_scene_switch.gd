extends ButtonForProject

@export var target_scene_path:String
@export var play_music := false

func _on_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(target_scene_path)
	if play_music:
		AudioPlayer.default_music.play()
