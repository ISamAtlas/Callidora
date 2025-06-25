extends Node2D

@export var zoom_adjust:Vector2

var mutex := Mutex.new()

func _physics_process(_delta:float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart.call_deferred()

func victory() -> void:
	Global.seal1()
	set_process_mode.call_deferred(PROCESS_MODE_DISABLED)

func restart() -> void:
	var current_pos := global_position
	var current_scale := scale
	var parent := get_parent()
	
	mutex.lock()
	var puzzle := load("res://scenes/levels/marble_puzzle.tscn")
	
	var puzzle_spawn:Node2D = puzzle.instantiate()
	puzzle_spawn.global_position = current_pos
	puzzle_spawn.scale = current_scale
	
	parent.add_child(puzzle_spawn)
	mutex.unlock()
	queue_free()

func new_zoom() -> Vector2:
	return Vector2(2.7,2.7)

func _on_area_2d_body_exited(_body:Node2D) -> void:
	restart.call_deferred()
