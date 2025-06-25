extends Node2D

@onready var anim = $AnimationPlayer


func _ready() -> void:
	anim.play("fade_in")
