extends Node
var count = 0
var spawn_speed = 0
var check_spawn = [false, false, false, false, false, false, false, false, false, false, ]

const enemy_box = preload("res://Scenes/Box.tscn")
func _ready():
	spawn()
	pass
	
func game_over():
	var pause_state = not get_tree().paused
	get_tree().paused = not get_tree().paused	
	print('game over')

func spawn():
	while true:
		randomize()
		var box = enemy_box.instance()
		var pos = Vector2()
		var pos_x = round(rand_range(0.0, 9.0))
		var check = check_spawn[int(pos_x)]
		while check:
			if pos_x == 9.0:
				pos_x = 0.0
			else: pos_x += 1.0
			check = check_spawn[int(pos_x)]
		pos.x = (pos_x*128+64)
		pos.y = 64
		box.position.x = pos.x
		box.position.y = pos.y
		utils.score_current += 25
		get_node("container").add_child(box)
		spawn_speed = utils.score_current * 0.0001
		yield(utils.create_timer(3.5 - pow((1.0+1.0/spawn_speed),spawn_speed)), "timeout")
		if utils.count_on_floor > 9:
			$StaticBody2D2/anim.play("wroom")
		

func _on_Area2D_body_entered():
	check_spawn[0] = true

func _on_Area2D2_body_entered():
	check_spawn[1] = true

func _on_Area2D3_body_entered():
	check_spawn[2] = true

func _on_Area2D4_body_entered():
	check_spawn[3] = true

func _on_Area2D5_body_entered():
	check_spawn[4] = true

func _on_Area2D6_body_entered():
	check_spawn[5] = true

func _on_Area2D7_body_entered():
	check_spawn[6] = true

func _on_Area2D8_body_entered():
	check_spawn[7] = true

func _on_Area2D9_body_entered():
	check_spawn[8] = true

func _on_Area2D10_body_entered():
	check_spawn[9] = true

func _on_Area2D_body_exited():
	check_spawn[0] = false

func _on_Area2D2_body_exited():
	check_spawn[1] = false

func _on_Area2D4_body_exited():
	check_spawn[3] = false

func _on_Area2D6_body_exited():
	check_spawn[5] = false

func _on_Area2D8_body_exited():
	check_spawn[7] = false

func _on_Area2D10_body_exited():
	check_spawn[9] = false

func _on_Area2D9_body_exited():
	check_spawn[8] = false

func _on_Area2D3_body_exited():
	check_spawn[2] = false

func _on_Area2D5_body_exited():
	check_spawn[4] = false

func _on_Area2D7_body_exited():
	check_spawn[6] = false
