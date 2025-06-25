extends RigidBody2D

func _ready() -> void:
	var children := [$Sprite2D,$CollisionShape2D]
	var new_scale:Vector2 = get_parent().scale
	for child in children:
		child.scale *= new_scale
