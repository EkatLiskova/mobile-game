extends KinematicBody2D

onready var right = get_node("right")
onready var left = get_node("left")


const GRAVITY_VEC = Vector2(0,100)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 1.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 100 # pixels/sec
const SIDING_CHANGE_SPEED = 10

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false


#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func _physics_process(delta):
	#increment counters

	onair_time += delta

	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0
		linear_vel.y = 0
	on_floor = onair_time < MIN_ONAIR_TIME

	# Horizontal Movement
	var target_speed = 0
	if right.is_colliding() and Input.is_action_pressed("ui_left"):
		target_speed += -1
	if left.is_colliding() and Input.is_action_pressed("ui_right"):
		target_speed += 1
	target_speed *= WALK_SPEED
	linear_vel.x = target_speed


