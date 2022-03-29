extends FSM_state

var jump_timer
var can_jump_again
var margin_jump_timer

func initialize():
	obj.anim_next = "fall"
	can_jump_again = false
	jump_timer = 0.0
	margin_jump_timer = obj.JUMP_MARGIN

func run(delta):
	if jump_timer >0: jump_timer -= delta
	if margin_jump_timer >0: margin_jump_timer -= delta

	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)

	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if abs(dir):
		dir = sign(dir)
		obj.velo.x = lerp(obj.velo.x, obj.MAX_SPEED * dir, obj.AIR_ACCEL)
		obj.dir_next = dir
	else:
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)

	obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		# jump immediately when touch the ground
		jump_timer = obj.JUMP_AGAIN_TIME
		can_jump_again = true
		# jump when just fall off the cliff
		if margin_jump_timer > 0 and \
			fsm.state_last != fsm.states.jump and \
			fsm.state_last != fsm.states.double_jump and\
			fsm.state_last != fsm.states.air_attack:
			
			obj.jump()
			fsm.state_next = fsm.states.jump
			return
		# fall and then double jump
		elif fsm.state_last != fsm.states.jump and not obj.has_double_jumped:
			if Gamestate.state.can_double_jump:
				fsm.state_next = fsm.states.double_jump
				return
		# regular double jump
		elif fsm.state_last == fsm.states.jump and not obj.has_double_jumped:
			if Gamestate.state.can_double_jump:
				fsm.state_next = fsm.states.double_jump
				return 

	if obj.is_on_floor():
		obj.has_double_jumped = false
		if can_jump_again and jump_timer >= 0:
			obj.jump()
			fsm.state_next = fsm.states.jump
		else:
			if abs(obj.velo.x):
				fsm.state_next = fsm.states.run
			else:
				fsm.state_next = fsm.states.idle
	
	if Input.is_action_just_pressed("dash") and obj.can_dash():
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

	if Input.is_action_just_pressed("attack"):
		fsm.state_next = fsm.states.air_attack
		return
