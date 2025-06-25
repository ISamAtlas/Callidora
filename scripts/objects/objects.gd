extends Area2D

@export var texture := preload("res://assets/objects/trial2/test.png")
@onready var GRAVITY := 600.0
@export var item_type:String

func _ready() -> void:
	$object.set_texture(texture)
	$shadow.set_texture(texture)
	
