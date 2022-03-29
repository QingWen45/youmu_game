extends FSM_state


var death_timer : float
var anim_played : bool

func initialize():
	obj.emit_signal("player_dead")
	if Game.main:
		Game.main.bgm_change("")
	Engine.time_scale = 0.8
	death_timer = 1.0
	anim_played = false
	obj.anim_next = "hit"
	obj.get_node("hurtbox/collider").disabled = true
	

func run( delta ):
	obj.velo.y = min(obj.MAX_FALL_SPEED, obj.velo.y + obj.GRAVITY * delta)
	if obj.is_on_floor():
		obj.velo.x = lerp(obj.velo.x, 0, obj.AIR_ACCEL)

	obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)

	if obj.is_on_floor() and not anim_played:
		anim_played = true
		obj.anim_next = "death"

	if death_timer > 0:
		death_timer -= delta
		if death_timer <= 0:
			Engine.time_scale = 1.0
			$death_timer.start(2.0)
			obj.emit_signal("player_dead")
