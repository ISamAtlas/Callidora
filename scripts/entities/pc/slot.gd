extends Node2D

@onready var sprite := $slot_texture
@onready var occupied := false
@onready var object := preload("res://scenes/objects/texture.tscn")
@export_range(1,5,1) var slot_numb := 1

var item_texture:CompressedTexture2D
var item_type:String
var texture_offset:Vector2

func _ready() -> void:
	if slot_numb == 1:
		sprite.set_frame(0)

func clear_slot() -> void:
	for child in get_children():
		if child != sprite:
			child.queue_free()
			occupied = false

func give_item(item):
	if item != self:
		occupied = true
		item_texture = item.get_parent().texture
		item_type = item.get_parent().item_type
		texture_offset = item.get_parent().texture_offset
		
		var instance := object.instantiate()
		instance.position = Vector2(0,-5)
		instance.scale/=10
		instance.get_child(0).queue_free()
		instance.texture = item_texture
		instance.item_type = item_type
		
		item.get_parent().queue_free()
		add_child(instance)

func deselect() -> void:
	sprite.set_frame(1)

func select() -> void:
	sprite.set_frame(0)


