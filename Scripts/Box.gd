extends RigidBody2D

var red_box = preload("res://Sprites/Environment/RedCrate.png")
var blue_box = preload("res://Sprites/Environment/BlueCrate.png")
var brown_box = preload("res://Sprites/Environment/BrownCrate.png")

var AIR_ACCEL = 50.0
var AIR_DEACCEL = 1000.0
var count_on_floor = 0
var on_floor = 0.0
var MAX_FLOOR_AIRBORNE_TIME = 0.01
var airborne_time = 1e20
var destroy = false
var color = 0
var same_color_count = 0
var falling = true
var floor_h_velocity = 0.0

#const game = preload("res://Scenes/Scene.tscn")

onready var box_sprite = get_node("Sprite")

func _ready():
	randomize()
	color = (round(rand_range(0.0, 2.0)))
	add_to_group(utils.GROUP_BOXES)
	change_color(color)
	yield(utils.create_timer(0.8), "timeout")
	change_color(color)
	gravity_scale = 3
	
func change_color(color):
	if  (color == 0):
		box_sprite.set_texture(red_box)
		add_to_group(utils.RED_BOXES)
	elif(color == 1):
		box_sprite.set_texture(blue_box)
		add_to_group(utils.BLUE_BOXES)
	else:
		box_sprite.set_texture(brown_box)
		add_to_group(utils.BROWN_BOXES)
	

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	falling = not found_floor
	
	# A good idea when implementing characters of all kinds,
	# compensates for physics imprecision, as well as human reaction delay.
	
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	if destroy:
		utils.score_current += 100
		queue_free()
	
	if same_color_count >= 3:
		yield(utils.create_timer(1.0), "timeout")
		if same_color_count >= 3:
			same_color_count = 0
			$anim.play('destroy')
	
#
func _on_Area2D_body_entered(body):
	if (color == 0 and body.is_in_group(utils.RED_BOXES))or(color == 1 and body.is_in_group(utils.BLUE_BOXES))or(color == 2 and body.is_in_group(utils.BROWN_BOXES)):
		same_color_count += 1

func _on_Area2D_body_exited(body):
	if (color == 0 and body.is_in_group(utils.RED_BOXES))or(color == 1 and body.is_in_group(utils.BLUE_BOXES))or(color == 2 and body.is_in_group(utils.BROWN_BOXES)):
		same_color_count -= 1

func _on_Area2D2_body_entered(body):
	if (color == 0 and body.is_in_group(utils.RED_BOXES))or(color == 1 and body.is_in_group(utils.BLUE_BOXES))or(color == 2 and body.is_in_group(utils.BROWN_BOXES)):
		body.same_color_count = 1
		body.destroy = true
