extends CharacterBody2D

@onready var anim := $playerSprite
@onready var camera := $Camera2D
@onready var inventory := $camera_switch/CanvasLayer/inventory
@onready var health_bar = $camera_switch/CanvasLayer/health_bar
@onready var animation_player = $AnimationPlayer
@onready var dialogue_area := $dialogue_trigger
@onready var mirror := $mirror
@onready var command_label := $camera_switch/CanvasLayer/commandsLeft
@onready var shadow = $Shadow

@onready var commands := 0:
	set(command_used):
		commands = command_used
		command_label.set_text("Commands Left: " + str(commands) + "\n[F]")
		
		if commands != 4:
			
			msg_clr = Color("92b6ff")
			msg_size = 180
			bubble_type = 2
			msg = "Submit."
			Global.emit_signal("stun")
			AudioPlayer.command.play()

@onready var object := preload("res://scenes/objects/rigid_body_object.tscn")
@onready var level := 0:
	set(new_level):
		AudioPlayer.achievement.play()
		var layer_del := 0
		match new_level:
			1: 
				layer_del = 4096 #disable 13
				command_label.show()
				$camera_switch/CanvasLayer/inventory.show()
				commands = 4
			2:
				layer_del = 8192 #disable 14
				if Global.level2:
					commands -= 1
				focus_correct = true
				state = "normal"
			3: 
				layer_del = 16384 #disable 15
				Global.last_pos = Vector2(2667, 714)
				init_camera_zoom /= 2
				focus_correct = true
				cooldown = false
				health_bar.show()
				shadow.show()
				$camera_switch/CanvasLayer/trojan_shadow.show()
				
		dialogue_area.collision_mask -= layer_del
		collision_mask -= layer_del
		level = new_level
		
		$playerSprite/player_effects.play("gaining")
var cooldown := true:
	set(state):
		cooldown = state
		if state:
			$cld.start()

var bubble_type:int
var msg_size:int
var msg_clr:Color
var msg:String:
	set(to_send):
		msg = to_send
		overhead_dialogue(msg)

@onready var init_camera_pos:Vector2
@onready var init_camera_zoom:Vector2
var camera_speed := 1.0

var diff_focus:bool
var target_focus:Area2D:
	set(new_focus):
		target_focus = new_focus
		if target_focus != null:
			diff_focus = true
var focus_correct:bool:
	set(focal_point):
		if focal_point:
			diff_focus = false
			target_focus = null
		focus_correct = focal_point

var target_pos:Vector2
var camera_pos:Vector2
var camera_zoom:Vector2
var target_zoom:Vector2
var default_camera_pos:Vector2

@export var JUMP := -8000.0 * 1.45
@export var WALKING_SPEED := 1400.0 * 3.8
@export var GRAVITY := 600.0

var sound_type := "grass"

var HEALTH = 100

var can_collect:=false
var attacking:=false
var can_place:=false
var item:Node2D
var selected_slot := 1

var on_reflect := false
var reflection:Area2D
var state := "normal"

func _ready() -> void:
	
	Global.connect("player_death", _on_death)
	Global.connect("seal_update", _on_seal_lift)
	Global.connect("boss_death", _boss_died)
	Global.connect("callidora", _send_message)
	
	$camera_switch/CanvasLayer.show()
	init_camera_pos = camera.get_position()
	init_camera_zoom = camera.get_zoom()
	health_bar.init_health(HEALTH)

func _boss_died() -> void:
	msg_size = 30*2
	msg_clr = Color("FFFFFF")
	bubble_type = 1
	msg = "free... I'm, I'm finally free! I'm leaving. Never coming back HAHA"
	init_camera_zoom *= 2

func _on_death() -> void:
	AudioPlayer.death.play()
	HEALTH = 100
	health_bar.init_health(HEALTH)
	set_process_mode(Node.PROCESS_MODE_DISABLED)

func _physics_process(delta:float) -> void:
	if level>=3:
		shadow.show()
	
	if Input.is_action_just_pressed("command"):
		if commands > 0: commands -= 1
	
	if Input.is_action_just_pressed("trojan_shadow") and !cooldown:
		Global.emit_signal("trojan_shadow")
		cooldown = true
		$Shadow/AnimationPlayer.play("attacking")
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and state != "confrontation":
		if state == "reflection":
			$directions2.hide()
		velocity.y = JUMP * delta
		state = "normal"
		anim.show()
	
	match state:
		"normal":
			var direction := Input.get_axis("left", "right") * WALKING_SPEED * delta
			if direction:
				if is_on_floor():
					AudioPlayer.play_walk(sound_type)
				velocity.x = direction
				anim.play("run")
				if velocity.x > 0: #going right
					anim.set_flip_h(1)
				elif velocity.x < 0: #going left
					anim.set_flip_h(0)
			else:
				anim.play("idle")
				velocity.x = 0
			
			if Input.is_action_just_pressed("place") and can_place == true:
				item = inventory.get_slot()
				if item.occupied == true:
					var instance := object.instantiate()
					instance.set_pos = round(Vector2(get_global_mouse_position().x,get_global_position().y-30))
					instance.texture = item.item_texture
					instance.item_type = item.item_type
					instance.texture_offset = item.texture_offset
					_node_named("object_layer").add_child(instance)
					item.clear_slot()
		"reflection":
			velocity.x = 0
			shadow.hide()
			$directions2.show()
			
			if Input.is_action_just_pressed("right"):
				var next_mirror := _find_mirror("right")
				if next_mirror:
					AudioPlayer.tp.play()
					set_global_position(next_mirror)
			
			if Input.is_action_just_pressed("left"):
				var next_mirror := _find_mirror("left")
				if next_mirror:
					AudioPlayer.tp.play()
					set_global_position(next_mirror)
		"confrontation":
			velocity.x = 0
			anim.play("idle")
			
			if Input.is_action_just_pressed("skip"):
				Global.emit_signal("dialogue_skip")
			
	if !is_on_floor():
		shadow.hide()
		anim.play("jump")
		velocity.y += GRAVITY * delta
	
	if can_collect == true and Input.is_action_just_pressed("interact") and item != null:
		inventory.manage(item)
		
	if Input.is_action_just_pressed("scroll_down"):
		selected_slot = inventory.increment_selection(-1)
	if Input.is_action_just_pressed("scroll_up"):
		selected_slot = inventory.increment_selection(1)
	if Input.is_action_just_pressed("slot_change"):
		if Input.is_action_just_pressed("slot_one"):
			selected_slot = inventory.direct_selection(1)
		if Input.is_action_just_pressed("slot_two"):
			selected_slot = inventory.direct_selection(2)
		if Input.is_action_just_pressed("slot_three"):
			selected_slot = inventory.direct_selection(3)
		if Input.is_action_just_pressed("slot_four"):
			selected_slot = inventory.direct_selection(4)
		if Input.is_action_just_pressed("slot_five"):
			selected_slot = inventory.direct_selection(5)
	
	if on_reflect and Input.is_action_just_pressed("reflection") and level > 1:
		target_focus = reflection
		state = "reflection"
		anim.hide()
	
	if diff_focus: #change the object of focus
		
		camera_zoom = camera.get_zoom()
		target_zoom = target_focus.new_zoom()*2-camera_zoom #makes the average the answer given by new_zoom
		camera_pos = camera.get_global_position()
		target_pos = target_focus.get_global_position()
		if camera_pos != target_pos:
			camera.set_global_position(lerp(camera_pos, target_pos, camera_speed * delta))
		
		if camera_zoom != target_zoom:
			camera.set_zoom(lerp(camera_zoom, target_zoom, camera_speed * delta))
	if focus_correct: #change focus back if is not the same
		camera_pos = camera.get_global_position()
		default_camera_pos = get_global_position() + init_camera_pos
		
		camera.set_global_position(lerp(camera_pos, default_camera_pos, camera_speed * delta))
		camera_zoom = camera.get_zoom()
		camera.set_zoom(lerp(camera_zoom, init_camera_zoom, camera_speed * delta))

		if camera.get_global_position() == get_global_position() and camera.get_zoom() == target_focus.new_zoom():
			focus_correct = false #stops calculations
	
	move_and_slide()

func _on_area_2d_area_shape_exited(_area_rid:RID, _area:Area2D, _area_shape_index:int, _local_shape_index:int) -> void:
	can_collect = false
	item = null

func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int) -> void:
	can_collect = true
	item = area

func _on_placeable_zone_mouse_entered() -> void:
	can_place = true

func _on_placeable_zone_mouse_exited() -> void:
	can_place = false

func damage(dmg:float) -> void:
	animation_player.play("hurt")
		
	HEALTH -= dmg
	health_bar.health = HEALTH

func _node_named(target_name:String) -> Node2D:
	var confirmed_return:Node2D
	for child in get_tree().root.get_children():
		for child2 in child.get_children():
			if child2.name == target_name:
				confirmed_return = child2
	return confirmed_return

func _on_camera_switch_area_entered(area:Area2D) -> void:
	target_focus = area
func _on_camera_switch_area_exited(area:Area2D) -> void:
	focus_correct = true

func _on_seal_lift() -> void:
	Global.last_pos = get_global_position() 
	level = Global.level

func _on_mirror_area_entered(area:Area2D) -> void:
	on_reflect = true
	reflection = area

func _on_mirror_area_exited(area:Area2D) -> void:
	focus_correct = true
	on_reflect = false

func _on_dialogue_trigger_entered(body:Area2D) -> void:
	msg_size = body.msg_size
	msg_clr = body.msg_clr
	bubble_type = body.msg_type
	if body.has_method("data_fetched"):
		body.data_fetched()
	msg = body.get_dialogue()
	

func overhead_dialogue(text:String) -> void:
	$speech.stop()
	$SpeechBubble/Label.set("theme_override_font_sizes/font_size", msg_size*2)
	$SpeechBubble/Label.set("theme_override_colors/font_color", msg_clr)
	$SpeechBubble/Label.set_text(text)
	match bubble_type:
		1: $speech.play("classic_bubble")
		2: $speech.play("command_bubble")

func _find_mirror(input:String) -> Vector2:
	var reflecting_list := get_tree().get_nodes_in_group("reflecting")
	var whittled_list := []
	var confirmed_return:Vector2
	for node in reflecting_list:
		if input == "right" and reflection.get_global_position().x < node.get_global_position().x:
			whittled_list.append(node)
		if input == "left" and reflection.get_global_position().x > node.get_global_position().x:
			whittled_list.append(node)
	if whittled_list != []:
		var least_node := {"Node":null,"x_diff":null}
		for node in whittled_list:
			var node_x_diff:int 
			if input == "right":
				node_x_diff = node.get_global_position().x - reflection.get_global_position().x
			else:
				node_x_diff = reflection.get_global_position().x - node.get_global_position().x
			if (least_node["x_diff"] == null or node_x_diff < least_node["x_diff"]): 
				least_node["x_diff"] = node_x_diff
				least_node["Node"] = node
		var new_pos:Vector2 = least_node["Node"].get_global_position()
		confirmed_return = Vector2(new_pos.x, new_pos.y-10)
	return confirmed_return

func _on_confrontation_area_entered(area:Area2D) -> void:
	target_focus = area
	state = "confrontation"

func _on_cld_timeout():
	cooldown = false


func _on_sound_change_entered(area:Area2D) -> void:
	sound_type = "stone"

func _on_sound_change_exited(area:Area2D) -> void:
	sound_type = "grass"

func _send_message() -> void:
	bubble_type = 1
	msg_size = 90
	msg_clr = Color("FFFFFF")
	msg = "Goodbye my child, callidora"
