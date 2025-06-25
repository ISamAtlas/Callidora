extends Sprite2D

@onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("shrink")

func _on_timer_timeout():
	queue_free()
