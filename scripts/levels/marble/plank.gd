extends Node2D

@export_category("Platform Settings")

@export_group("General")
@export var rotatable := true
@export var speed:float= 2
@export var auto_spin:= false

@export_group("Travel Range")
@export var enable := false
@export_enum("pos1","pos2") var plat_dir := "pos2"
@export var platform_speed := 0.0
@export var min_dis:Vector2
@export var max_dis:Vector2
var relative_pos1:Vector2
var relative_pos2:Vector2

@export_group("Unused")
@export var texture:CompressedTexture2D
@export var pivot_offset := Vector2(0,0)

@onready var children := [$Sprite2D,$StaticBody2D]

func _ready() -> void:
	relative_pos1 = Vector2(get_global_position().x + min_dis.x,get_global_position().y + min_dis.y)
	relative_pos2 = Vector2(get_global_position().x + max_dis.x,get_global_position().y + max_dis.y)
	if texture:
		$Sprite2D.texture = texture
	if !rotatable and !auto_spin and min_dis == Vector2(0,0) and max_dis == Vector2(0,0):
		set_physics_process(false)
	for child in children:
		child.position = pivot_offset

func _physics_process(delta:float) -> void:
	var rotate_call := 0.0
	if rotatable:
		rotate_call = Input.get_axis("tilt_left", "tilt_right") * speed * delta
	if auto_spin:
		rotate_call += speed * delta
	if rotate_call:
		rotation += rotate_call
	if enable:
		var target_pos:Vector2
		if plat_dir == "pos2":
			target_pos = relative_pos2
		else:
			target_pos = relative_pos1
		
		if get_global_position().snapped(Vector2(1,1)) == target_pos:
			if plat_dir == "pos2":
				plat_dir = "pos1"
			else:
				plat_dir = "pos2"
		set_global_position(lerp(get_global_position(), target_pos, platform_speed * delta))
	
func victory() -> void:
	get_parent().victory()
