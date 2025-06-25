extends Area2D

@export var zoom := Vector2(5.5,5.5)

func new_zoom() -> Vector2:
	return zoom


func _on_area_2d_area_entered(area:Area2D) -> void:
	if area.get_parent().level >= 2:
		$R.show()


func _on_area_2d_area_exited(area:Area2D) -> void:
	$R.hide()
