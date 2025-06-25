extends Area2D

@export var bounce_velocity := 1
@export var victory_pad := false

func _on_body_entered(body: Node2D) -> void:
	if victory_pad:
		get_parent().victory()
	
	var velocity:Vector2 = body.linear_velocity
	body.linear_velocity.y = -1*bounce_velocity * (abs(velocity.y) * 0.9)

func new_zoom() -> Vector2:
	return get_parent().new_zoom()
