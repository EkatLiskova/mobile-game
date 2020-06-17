extends RigidBody2D


# Member variables
var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var shooting = false

var WALK_ACCEL = 2000.0
var WALK_DEACCEL = 3000.0
var WALK_MAX_VELOCITY = 450.0
var AIR_ACCEL = 1000.0
var AIR_DEACCEL = 500.0
var JUMP_VELOCITY = 1000
var STOP_JUMP_FORCE = 2000.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20
var shoot_time = 1e20
var new_anim = anim

var MAX_SHOOT_POSE_TIME = 0.3

var floor_h_velocity = 0.0

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	
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
			
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
				$raycast.cast_to.x = -40
				if $raycast.is_colliding():
					new_anim = "pushing"
					WALK_MAX_VELOCITY = 250.0
				else:
					new_anim = "run"
					WALK_MAX_VELOCITY = 450.0
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
				$raycast.cast_to.x = 40
				if $raycast.is_colliding():
					new_anim = "pushing"
					WALK_MAX_VELOCITY = 250.0
				else:
					new_anim = "run"
					WALK_MAX_VELOCITY = 450.0
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
			new_anim = "idle"
			if lv.y < 0:
				new_anim = "jump"
			else:
				new_anim = "jump_down"
		# Check jump
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
		
		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
			
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

	# Update siding
	if new_siding_left != siding_left:
		if new_siding_left:
			$sprite.scale.x = -1.25
		else:
			$sprite.scale.x = 1.25
		
		siding_left = new_siding_left
 	
	
	# Change animation
	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)
	
	
	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	pass # replace with function body
