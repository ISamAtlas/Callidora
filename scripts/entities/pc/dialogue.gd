extends Area2D

class_name dialogue

@export var text:String
@export var msg_size := 80
@export var msg_clr:Color = Color("#FFFFFF")
@export var repeatable := false
@export_range(1,2) var msg_type := 1

func get_dialogue() -> String:
	if !repeatable:
		queue_free()
	return text
