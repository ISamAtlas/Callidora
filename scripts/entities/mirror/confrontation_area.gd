extends Area2D

var zoom := Vector2(5,5)
var has_init := false
@onready var prompt_img := $"../CanvasLayer/LargeMessage"

@onready var anim := $"../AnimationPlayer"
@onready var anim2 = $"../AnimationPlayer2"


@onready var prompt = $"../CanvasLayer/LargeMessage/posed_question"
@onready var opt1 = $"../CanvasLayer/LargeMessage/option1/Label"
@onready var opt2 = $"../CanvasLayer/LargeMessage/option2/Label"

@onready var question_update := $"../question_update"
@onready var opt_update = $"../response_update"

var failed := false
var question := 1

func _ready():
	Global.connect("dialogue_skip", _skip_dialogue)
	prompt_img.hide()
	$"../CanvasLayer/LargeMessage/Label".hide()
	prompt_img.set_modulate(Color(1,1,1,0))
	
func new_zoom() -> Vector2:
	
	if !has_init:
		init()
	
	return zoom

func init() -> void:
	anim.set_current_animation("init")
	anim2.play("flash")
	anim.queue("init_write")
	prompt_img.show()
	has_init = true

func _skip_dialogue():
	if anim.current_animation != "init_show" or anim.current_animation == "init_write":
		anim.play("RESET")
		question_update.stop()
		opt_update.stop()
		_on_add_response_timeout()
		_on_add_question()
		
func _on_option_1_pressed() -> void:
	if question == 8:
		question+=1
	common_response(1)

func _on_option_2_pressed() -> void:
	common_response(2)

func common_response(option:int) -> void:
	if question != 10:
		question += 1
		question_update.start()
		opt_update.start()
		anim.play("rewrite")
		

func _on_add_question():
	match question:
		2: prompt.set_text("What is it that is yours, what is it that is unjust?")
		3: prompt.set_text("Have you not been judged?")
		4: prompt.set_text("What have you done to allow this decision?")
		5: prompt.set_text("Do you regret it?")
		6: prompt.set_text("And those around you?")
		7: prompt.set_text("Does it matter?")
		8: prompt.set_text("What have you lost in arriving here?")
		9: prompt.set_text("You have not truly reflected.")
		10: prompt.set_text("")


func _on_add_response_timeout():
	match question:
		2: 
			opt1.set_text("My reflection, my divine throne have been taken from me")
			opt2.set_text("My perceived presence in the locale of gods. It is where I belong")
			font_size(16)
		3:
			opt1.set_text("I have, that is what I cannot agree with")
			opt2.set_text("Yes, I have been \n“judged”")
			font_size(20,25)
		4: 
			opt1.set_text("I have followed my morals")
			opt2.set_text("I have broken the rules")
			font_size(25)
		5:
			opt1.set_text("I do not, however, I will gain back my power")
			opt2.set_text("I do not, however, I will not live as a mortal")
			font_size(15)
		6:
			opt1.set_text("I do not know")
			opt2.set_text("I do not know")
			font_size(25)
		8:
			opt1.set_text("Nothing")
			opt2.set_text("Everything")
		9:
			opt1.set_text("SUBMIT TO ME")
			opt2.set_text("SUBMIT TO ME")
			opt1.set("theme_override_colors/font_color", "92b6ff")
			opt2.set("theme_override_colors/font_color", "92b6ff")
			font_size(30)
			failed = true
		10:
			opt1.set_text("")
			opt2.set_text("")
			Global.conversation_end(failed)
			get_parent().queue_free()

func font_size(one:int,two:int = one) -> void:
	opt1.set("theme_override_font_sizes/font_size", one)
	opt2.set("theme_override_font_sizes/font_size", two)
