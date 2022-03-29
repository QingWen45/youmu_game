extends FSM_state

var defeat_timer

func initialize():
	defeat_timer = 0.0
	Engine.time_scale = 0.8
	obj.disable_collider()
	obj.anim_next = "hit"
	obj.anim_fan.play("stop")
	obj.fan.hide()
	obj.velo.x = -obj.dir_cur * 40
	obj.velo.y = -150
	obj.anim_float.play("stop")

var once = true
func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)

	defeat_timer += delta
	if defeat_timer > 1.0 and once:
		once = false
		Engine.time_scale = 1.0
		Gamestate.clear_boss()

	if defeat_timer > 5.0:
		obj.queue_free()
	
	

