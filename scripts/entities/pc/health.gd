extends ProgressBar

@export var player := false

@onready var timer := $Timer
@onready var damage_bar := $damage

var health := 0.0 : set = _set_health

func _set_health(new_health:float) -> void:
	var prev_health := health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		if player:
			Global.emit_signal("player_death")
		else:
			queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health:float) -> void:
	max_value = _health #recommended by a comment
	health = _health
	#health = _health
	#max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
