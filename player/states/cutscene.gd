extends FSM_state


func initialize():
	if obj.is_on_floor():
		obj.anim_next = "idle"
	else:
		obj.anim_next = "fall"


func run(delta):
	obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)

	if obj.is_on_floor():
		obj.anim_next = "idle"

