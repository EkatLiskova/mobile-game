extends Control

func _input(event):
	if event.is_action_pressed("pause"):	
		var pause_state = not get_tree().paused
		get_tree().paused = not get_tree().paused	
		visible = pause_state
		
func _on_Button_pressed():
	$sound_click.play()
	#yield(utils.create_timer(0.2), "timeout")
	utils.score_current = 0
	var pause_state = not get_tree().paused
	get_tree().reload_current_scene()
	get_tree().paused = not get_tree().paused	
	visible = pause_state
	
func _on_Button2_pressed():
	$sound_click.play()
	#yield(utils.create_timer(1.0), "timeout")
	get_tree().change_scene('res://Scenes/Menu.tscn')
	get_tree().paused = not get_tree().paused
	utils.score_current = 0


func _on_Button3_pressed():
	$sound_click.play()
	yield(utils.create_timer(1.0), "timeout")
	var pause_state = not get_tree().paused
	get_tree().paused = not get_tree().paused	
	visible = pause_state
