extends Node

@onready var grass_walk := $sfx/walk2/grass_walk
@onready var stone_walk := $sfx/walk2/stone_walk
@onready var walk := $sfx/walk2/cd

@onready var pickup := $sfx/pickup
@onready var tp = $sfx/tp
@onready var click = $sfx/click

@onready var mgc_atk := $sfx/mgc_atk
@onready var command := $sfx/command
@onready var default_music := $music/default
@onready var anim := $music/AnimationPlayer

@onready var battle_loop = $music/battle_loop
@onready var battle_intro = $music/battle_intro

@onready var achievement = $sfx/achievement
@onready var death = $sfx/death


var can_walk := true:
	set(state):
		can_walk = state
		if !can_walk:
			walk.start()

func play_walk(type:String) -> void:
	if can_walk:
		can_walk = false
		if type == "grass":
			grass_walk.play()
		else:
			stone_walk.play()

func _on_walk_timeout() -> void:
	can_walk = true

func _on_battle_intro_finished() -> void:
	battle_loop.play()

