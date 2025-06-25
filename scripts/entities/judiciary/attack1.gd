extends Node2D

@onready var sprite = $Sprite2D

func _ready():
	var state := randi_range(1,5)
	match state:
		2: sprite.flip_h = true
		3: sprite.flip_v = true
		4: 
			sprite.flip_h = true
			sprite.flip_v = true
		5:
			pass
	var size := randf_range(0.5,1.3)
	scale = Vector2(size,size)

func _on_disappear_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body:Node2D) -> void:
	var dmg := randi_range(10,15)
	body.damage(dmg)
	$Area2D.queue_free()
