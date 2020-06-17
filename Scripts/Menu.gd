extends Node

func _on_Exit_pressed():
	$Menu_UI/ColorRect/anim.play("FadeIn")
	yield(utils.create_timer(rand_range(1.0, 1.0)), "timeout")
	get_tree().quit()

func _on_Play_pressed():
	$Menu_UI/ColorRect/anim.play("FadeIn")
	yield(utils.create_timer(rand_range(1.0, 1.0)), "timeout")
	get_tree().change_scene('res://Scenes/Scene.tscn')

func _on_Settings_pressed():
	$Menu_UI/ColorRect/anim.play("FadeIn")
	yield(utils.create_timer(rand_range(1.0, 1.0)), "timeout")
	get_tree().reload_current_scene()

