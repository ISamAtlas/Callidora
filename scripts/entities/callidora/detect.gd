extends Area2D

func new_zoom() -> Vector2:
	return get_parent().new_zoom()
