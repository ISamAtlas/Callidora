extends Node2D

@onready var anim := $AnimationPlayer
@onready var inventory := $"../inventory"
@onready var health_bar = $"../health_bar"
@onready var character := $"../../.."

func _ready() -> void:
	Global.connect("player_death", _player_died)

func _player_died() -> void:
	inventory.hide()
	health_bar.hide()
	anim.play("died")

func _player_respawn() -> void:
	anim.play("respawn")
	inventory.show()
	health_bar.show()
	character.set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
	character.set_global_position(Global.last_pos)

func _on_respawn_pressed() -> void:
	_player_respawn()
