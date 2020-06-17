extends Node

var count = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group(utils.GROUP_BOXES):
		utils.count_on_floor += 1
		

func _on_Area2D_body_exited(body):
	if body.is_in_group(utils.GROUP_BOXES):
		utils.count_on_floor -= 1
	
func _on_destroy2_body_entered(body):
	if body.is_in_group(utils.GROUP_BOXES):
		body.destroy = true

func _on_Area2D_script_changed():
	pass





