extends FSM_state

onready var timer = $Timer

func initialize():
	# create_step()
	timer.start(0.38)
	obj.anim_next = "move"

func run(_delta):
	if Input.is_action_just_pressed("jump"):
		obj.jump()
		fsm.state_next = fsm.states.jump
		return

	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")

	if abs(dir) > 0:
		dir = sign(dir)
		obj.velo = obj.move_and_slide_with_snap( \
			Vector2( obj.MAX_SPEED, 0 ) * dir, \
			Vector2.DOWN * 8, \
			Vector2.UP )
		obj.dir_next = dir
	else:
		fsm.state_next = fsm.states.idle
		return
	
	if not obj.is_on_floor():
		fsm.state_next = fsm.states.fall
		return

	if Input.is_action_just_pressed("attack"):
		fsm.state_next = fsm.states.attack1
		return
	
	if Input.is_action_just_pressed("dash") and obj.can_dash():
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

func terminate():
	timer.stop()

func create_step():
	var pitch = rand_range(1, 1.2)
	obj.step_mp.pitch_scale = pitch
	obj.step_mp.play()

func _on_Timer_timeout():
	create_step()

