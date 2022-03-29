extends FSM_state

func initialize():
	obj.ray.enabled = true
	obj.anim_next = "hit"
	obj.anim_fan.play("stop")
	obj.fan.hide()
	obj.velo.x = -obj.dir_cur * 40
	obj.velo.y = -50
	obj.anim_float.play("stop")

func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if obj.ray.is_colliding():
		obj.ray.enabled = false
		obj.velo = Vector2.ZERO
		fsm.state_next = fsm.states.stun

	obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)
	

