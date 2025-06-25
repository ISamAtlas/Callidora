extends Node2D

@onready var anim = $AnimationPlayer
var bruh := 0:
	set(yeah):
		bruh = yeah
		if bruh == 2:
			get_tree().change_scene_to_file("res://scenes/levels/game_one.tscn")

@export var completed := false:
	set(new_state):
		completed = new_state
		if completed == true:
			bruh += 1

func _ready() -> void:
	set_physics_process(false)
	anim.play("intro")
	if Global.intro:
		set_physics_process(true)
		$Label2.show()
	Global.intro = true
	

func _physics_process(delta:float) -> void:
	if Input.is_action_just_pressed("skip"):
		bruh = 2
