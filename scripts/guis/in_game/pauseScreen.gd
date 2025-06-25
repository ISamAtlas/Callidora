extends Node2D

var pauseState:=false

func _physics_process(delta:float) -> void:
	if Input.is_action_just_pressed("escape_menu"):
		visible = pause()
		$options.visible = false

func pause() -> bool:	
	if pauseState:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		pauseState = false
	else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pauseState = true
	return pauseState


func _on_resume_pressed() -> void:
	visible = pause()


func _on_options_pressed() -> void:
	$PanelContainer/pause_screen.visible = false
	$options.visible = true


func _on_back_pressed() -> void:
	$PanelContainer/pause_screen.visible = true
	$options.visible = false
