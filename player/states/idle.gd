extends FSM_state


func initialize():
	obj.velo = Vector2.ZERO
	obj.anim_next = "idle"


func run(_delta):
	if obj.is_on_floor():
		var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
		if abs(dir):
			fsm.state_next = fsm.states.run
			return

		if not Input.is_action_pressed("down") and Input.is_action_just_pressed("jump"):
			obj.jump()
			fsm.state_next = fsm.states.jump
			return

	else:
		fsm.state_next = fsm.states.fall
		return

	if Input.is_action_just_pressed("dash") and obj.can_dash():
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

	if Input.is_action_just_pressed("attack"):
		fsm.state_next = fsm.states.attack1
		return
