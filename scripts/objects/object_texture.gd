extends RigidBody2D
@export var texture:CompressedTexture2D
@export var new_scale := 0.04
@export var item_type:String
@export var texture_offset:Vector2
var set_pos:Vector2

func _ready() -> void:
	if set_pos:
		set_global_position(set_pos)
	$Area2D/object.set_texture(texture)
	$Area2D/shadow.set_texture(texture)
	$Area2D.scale = Vector2(new_scale,new_scale)
	$CollisionShape2D.scale = Vector2(new_scale*5,new_scale*5)
	$E.scale = Vector2(0.1,0.1)
	
	$Area2D.position += texture_offset
func _on_area_2d_area_entered(area:Area2D) -> void:
	$E.show()

func _on_area_2d_area_exited(area:Area2D) -> void:
	$E.hide()
