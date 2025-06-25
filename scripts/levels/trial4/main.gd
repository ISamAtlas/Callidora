extends Node2D

var boss_puddle:Resource = load("res://scenes/levels/boss_puddles.tscn")

func _on_isolate_puddle_area_entered(area:Area2D) -> void:
	AudioPlayer.anim.play("fade_default")
	$isolate_puddle.queue_free()
	var reflecting_list := get_tree().get_nodes_in_group("reflecting")
	for node in reflecting_list:
		node.queue_free.call_deferred()
	add_child.call_deferred(boss_puddle.instantiate())
	
