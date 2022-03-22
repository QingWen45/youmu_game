extends FSM_state

var key_down_timer
var min_jump_ratio = 0.5
export (bool) var is_anim_end

func initialize():
	key_down_timer = 0.2
	obj.anim_next = "air_attack"
	is_anim_end = false
 

func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if key_down_timer > 0:
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
		if abs(dir):
			fsm.state_next = fsm.states.run
			return
		
		elif Input.is_action_pressed("attack"):
			fsm.state_next = fsm.states.attack1
			return
		
		else:
			fsm.state_next = fsm.states.idle
			return

	if is_anim_end:
		fsm.state_next = fsm.state_last

func set_anim_end():
	is_anim_end = true
