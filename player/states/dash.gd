extends FSM_state

onready var dash_timer
onready var timer = $Timer

func initialize():
	obj.anim_next = "jump"
	obj.hurt_shape.disabled = true
	dash_timer = obj.DASH_DURATION
	obj.is_invulnerable = true
	obj.invulnerable_timer = obj.DASH_DURATION + 0.2
	timer.start()

func run(delta):
	if dash_timer > 0:
		dash_timer -= delta
	else:
		fsm.state_next = fsm.states.idle
	
	obj.velo.x = lerp(obj.velo.x, 0, obj.DASH_DECAY)	
	obj.velo.y = 0

	obj.velo = obj.move_and_slide( obj.velo, Vector2.UP )

func terminate():
	obj.hurt_shape.disabled = false
	timer.stop()

func _on_Timer_timeout():
	obj.vs_create()