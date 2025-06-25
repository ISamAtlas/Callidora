extends StaticBody2D

var intruder:Node2D
var bread_crumb:Vector2
var dead := false


@onready var HEALTH := 100:
	set(new_value):
		if HEALTH > 0:
			health_bar.health = HEALTH
			HEALTH = new_value
			if HEALTH <= 0:
				Global.emit_signal("boss_death")
				dead = true
				$SpeechBubble/Label.set("theme_override_font_sizes/font_size", 60*2)
				$SpeechBubble/Label.set_text("Fate will find a way to force penance.")
				$focus_range.queue_free()
				AudioPlayer.anim.play("fade_battle")
				speech.play("classic_bubble")
				anim.play("death")
		
@onready var speech = $speech2
@onready var health_bar := $CanvasLayer/health_bar

@onready var focus_range = $focus_range
@onready var battle_init = $battleInit
@onready var reset_pos:Vector2
@onready var cd:Timer = $attack_cd
@onready var attacked_cd = $attacked_cd

@onready var attack := preload("res://scenes/entities/judiciary/attack1.tscn")
@onready var anim := $AnimationPlayer
@onready var anim2 = $AnimationPlayer2

@export var will_fight := false:
	set(state):
		will_fight = state
		if will_fight:
			updated = false

var updated := true


func _physics_process(delta:float) -> void:
	if will_fight and !updated:
		updated = true
		AudioPlayer.battle_intro.play()
		$focus_range.set_process_mode(Node.PROCESS_MODE_INHERIT)
		$battleInit.queue_free()
		set_physics_process(false)

func _ready() -> void:
	
	health_bar.init_health(HEALTH)
	reset_pos = get_global_position()
	Global.connect("player_death", _on_player_death)
	Global.connect("trojan_shadow", _attacked)
	Global.connect("stun", _stun)

func _attacked() -> void:
	if will_fight and !dead:
		attacked_cd.start()
		anim2.play("shadow")

func _stun() -> void:
	$attack_cd.stop()
	if intruder and !dead:
		cd.start(randf_range(1,2) + 5)
		anim.play("stunned")

func _on_player_death() -> void:
	HEALTH = 100
	set_global_position(reset_pos)

func _on_focus_entered(body:Node2D) -> void:
	intruder = body
	health_bar.show()
	cd.start(randf_range(0.5,2))

func _on_focus_exited(_body:Node2D) -> void:
	var bread_crumb:Vector2
	health_bar.hide()
	cd.stop()
	
func _on_attack_cd() -> void:
	cd.start(randf_range(0.5,2))
	if bread_crumb != null: _attack()
	bread_crumb = intruder.global_position

func _attack() -> void:
	var attack_send := attack.instantiate()
	attack_send.global_position = bread_crumb
	get_parent().add_child(attack_send)
	AudioPlayer.mgc_atk.play()


func _on_attacked_cd_timeout() -> void:
	var dmg := 15
	HEALTH -= dmg


func _on_battle_init(area:Area2D) -> void:
	$SpeechBubble/Label.set("theme_override_font_sizes/font_size", 60*2)
	$SpeechBubble/Label.set_text("A simple rule. Don't have children with mortals. It wasn't that hard.")
	speech.play("classic_bubble")
