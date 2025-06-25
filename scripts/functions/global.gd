extends Node

signal seal_update(level:int)
signal player_death()
signal dialogue_skip()

signal trojan_shadow()
signal stun()
signal boss_death()
signal callidora()

@onready var click := load("res://assets/misc/cursor/click.png")
@onready var intro := false


func _ready() -> void:
	Input.set_custom_mouse_cursor(click, Input.CURSOR_POINTING_HAND)
var level := 0:set = disable_seal
var last_pos:Vector2
var level2:bool


func disable_seal(new_level:int) -> void:
	level = new_level
	emit_signal("seal_update")

func seal1() -> void:
	level = 1

func conversation_end(failed:bool) -> void:
	level2 = failed
	level = 2
