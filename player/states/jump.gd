extends FSM_state

var key_down_timer
var min_jump_ratio = 0.5


func initialize():
	key_down_timer = 0.2
	if fsm.state_last != fsm.states.air_attack: 
		# input the verticle offset
		obj.anim_next = "jump"
		obj.jump_dust_generate(21)


func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if key_down_timer > 0:
		# when jump key's released, stop rising immediately
		key_down_timer -= delta
		if key_down_timer <= 0 or Input.is_action_just_released("jump"):
			key_down_timer = -1.0
			obj.velo.y *= min_jump_ratio
	
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if abs(dir):
		dir = sign(dir)
		obj.velo.x = lerp(obj.velo.x, obj.MAX_SPEED * dir, obj.AIR_ACCEL)
		obj.dir_next = dir
	else:
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)

	obj.velo = obj.move_and_slide( obj.velo, Vector2.UP )

	if obj.is_on_floor():
		fsm.state_next = fsm.states.idle
	elif obj.is_on_ceiling():
		obj.velo.y = 0.0
		fsm.state_next = fsm.states.fall
	else:
		if obj.velo.y > 0:
			fsm.state_next = fsm.states.fall

	if Input.is_action_just_pressed("jump"): # and Gamestate.state.can_double_jump:
		fsm.state_next = fsm.states.double_jump
		return

	if Input.is_action_just_pressed("dash") and obj.can_dash():
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

	if Input.is_action_just_pressed("attack"):
		fsm.state_next = fsm.states.air_attack
		return
 
