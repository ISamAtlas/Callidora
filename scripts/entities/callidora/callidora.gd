extends Node2D

@export var zoom := Vector2(4,4)

@onready var intervals = $intervals
@onready var speech = $speech

var message := 0
var text_start := false
var character:Node2D

func _on_area_2d_area_entered(area:Area2D) -> void:
	character = area.get_parent()
	character.state = "confrontation"
	
func new_zoom() -> Vector2:
	
	if !text_start:
		text_start = true
		intervals.start(1)
	
	return zoom

func _on_intervals_timeout() -> void:
	message += 1
	match message:
		1: 
			set_message("damn it, DAMN IT!", 100, "short")
		2:
			set_message("GOD DAMN IT!", 140, "angry_short")
		3:
			set_message("you’ve ruined everything. You couldn’t stop at messing with mortals, it’s like you’re mocking me.", 50, "medium")
		4:
			set_message("If only you had been less selfish, I could’ve resolved my everlasting pain.", 60, "medium")
		5:
			set_message("Everyday... the mere EXISTANCE of being part divine, part mortal... my body is at war with itself. It's destroyed and remade, sustaining and 'purifying' my mortal componants.", 37, "long")
		6:
			set_message("People bow to me as a demon from the depths of hell. Others throw salt at me. wishing me away.", 50, "medium")
		7:
			set_message("I had a chance to be OKAY.... to be a true God...", 70, "classic")
		8:
			set_message("i was willing to forget you, fade to oblivion, but you couldn’t even let me have this one thing. A body that doesn't writhe. Pure divinity.", 42, "long")
		9:
			set_message("Why I bother with the life you've given me is unknown.",65,"classic")
			AudioPlayer.anim.play("fade_default")
		
		10:
			speech.play("reveal_options")
		11:
			Global.emit_signal("callidora")
			intervals.start(3)
		12:
			speech.play("end")
			intervals.start(6)
		13:
			get_tree().change_scene_to_file("res://scenes/guis/credits.tscn")

func set_message(msg:String, size:int, bubble:String) -> void:
	var pause:float
	match bubble:
		"long": pause = 12
		"classic": pause = 4.2
		"short": pause = 2.2
		"angry_short": pause = 2.4
		"medium": pause = 6
	
	intervals.start(pause)
	
	$SpeechBubble/Label.set("theme_override_font_sizes/font_size", size*2)
	$SpeechBubble/Label.set_text(msg)
	speech.play(bubble)


func _pressed():
	speech.play_backwards("reveal_options")
	intervals.start(2)
