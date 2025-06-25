extends TextureButton
class_name ButtonForProject


func _init():
	var select := randi_range(1,5)
	mouse_default_cursor_shape = CURSOR_POINTING_HAND
	match select:
		1:
			set_texture_normal(load("res://assets/misc/buttons/regular/button.png"))
			set_texture_hover(load("res://assets/misc/buttons/hovering/button.png"))
		2:
			set_texture_normal(load("res://assets/misc/buttons/regular/rooted_button.png"))
			set_texture_hover(load("res://assets/misc/buttons/hovering/root_button.png"))
		3:
			set_texture_normal(load("res://assets/misc/buttons/regular/rooted_button_2.png"))
			set_texture_hover(load("res://assets/misc/buttons/hovering/root_button_2.png"))
		4:
			set_texture_normal(load("res://assets/misc/buttons/regular/vine_button_2.png"))
			set_texture_hover(load("res://assets/misc/buttons/hovering/vine_button.png"))
		5:
			set_texture_normal(load("res://assets/misc/buttons/regular/vine_button.png"))
			set_texture_hover(load("res://assets/misc/buttons/hovering/vine_button_2.png"))
	connect("pressed", _play_sound)

func _play_sound() -> void:
	AudioPlayer.click.play()
