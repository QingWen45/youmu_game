extends FSM_state

var _slash = preload("res://player/effects/slash.tscn")

var attack_timer
onready var timer = $Timer

func initialize():
	attack_timer = 0.6
	obj.anim_next = "charge_attack"
	obj.is_invulnerable = true
	obj.invulnerable_timer = 0.6
	timer.start()

func run(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		fsm.state_next = fsm.states.idle
		

	obj.velo.x = lerp(obj.velo.x, 0, obj.DASH_DECAY)	
	obj.velo.y = 0

	obj.velo = obj.move_and_slide_with_snap( obj.velo,Vector2.DOWN, Vector2.UP )


func terminate():
	timer.stop()

func _on_Timer_timeout():
	obj.vs_create()
