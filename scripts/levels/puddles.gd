extends Node


var puddle := preload("res://scenes/objects/puddle.tscn")

func _ready() -> void:
	Global.connect("boss_death", _add_puddle)
	
func _add_puddle() -> void:
	var new_puddle := puddle.instantiate()
	add_child(new_puddle)
	new_puddle.global_position = Vector2(3741, 6)
