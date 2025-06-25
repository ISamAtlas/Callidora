extends Node2D

@onready var TEXTURE = preload("res://scenes/objects/texture.tscn")
@onready var vanity = $vanity

var shadow_component := 0:
	set(new_value):
		shadow_component = new_value
		if new_value == 2:
			$detection/components/book.set_process_mode(Node.PROCESS_MODE_INHERIT)
		elif new_value == 3:
			dialogue_shift()

var shadow_state := 0:
	set(new):
		shadow_state = new
		dialogue_shift()
			

func _on_mirror_area_entered(area:Area2D) -> void:
	var object:Node2D = area.get_parent()
	if object.item_type == "mirror":
		object.collision_mask -= 1
		object.set_process_mode(Node.PROCESS_MODE_DISABLED)
		$"../dialogue_triggers/mirror_hint".queue_free()
		$detection/shadow_cast.set_process_mode(Node.PROCESS_MODE_INHERIT)
		$misc/mirrored_beam.show()


func _on_shadow_cast_area_entered(area:Area2D) -> void:
	$detection/shadow_cast.queue_free()
	$misc/top_shadow.show()
	shadow_state = 1

func dialogue_shift() -> void:
	
	if shadow_component == 3:
		$"../dialogue_triggers/instructions".text = "Well I still have this mirror... What could I use it for?"
	if shadow_state == 1:
		$"../dialogue_triggers/instructions".text = "How would I fill in the empty space?"
	if shadow_state == 1 and shadow_component == 3:
		$"../dialogue_triggers/instructions".text = "Been a long time eh?"
		Global.level = 3

func _on_boot_area_entered(area:Area2D) -> void:
	var object := area.get_parent()
	if object.item_type == "boot":
		object.collision_mask -= 1
		object.set_global_position(Vector2(1620.5,532))
		object.set_process_mode(Node.PROCESS_MODE_DISABLED)
		shadow_component += 1


func _on_broom_area_entered(area:Area2D) -> void:
	var object := area.get_parent()
	if object.item_type == "broom":
		object.collision_mask -= 1
		object.set_global_position(Vector2(1626,533))
		object.set_process_mode(Node.PROCESS_MODE_DISABLED)
		shadow_component += 1


func _on_book_area_entered(area:Area2D) -> void:
	var object := area.get_parent()
	if object.item_type == "book":
		object.set_global_position(Vector2(1624,520))
		object.collision_mask -= 1
		object.set_process_mode(Node.PROCESS_MODE_DISABLED)
		shadow_component += 1
