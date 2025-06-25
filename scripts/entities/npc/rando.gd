extends Area2D

func _on_area_entered(area:Area2D) -> void:
	area.get_parent().commands -= 1
	$AnimatedSprite2D.play("trance")
	$CollisionShape2D.queue_free()
