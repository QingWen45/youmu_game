extends FSM_state

var hurt_timer: float

func initialize():
	hurt_timer = 0.5
	obj.anim_next = "hit"
	obj.anim_fx.play("hit")
	obj.is_invulnerable = true
	obj.invulnerable_timer = 0.5


func run(delta):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if obj.is_on_floor():
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)

	obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)

	hurt_timer -= delta
	if hurt_timer < 0:
		if obj.is_on_floor():
			fsm.state_next = fsm.states.idle
		else:
			fsm.state_next = fsm.states.fall
