extends Sprite2D

var speed:= 4 # Modify it until satisfactory

func _physics_process(delta: float) -> void:
	region_rect.position.x -= speed * delta
