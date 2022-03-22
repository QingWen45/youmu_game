extends FSM_state

# spicify whether to enter attack phase 3
var attack_timer = 0
var first_attack

func initialize():
	first_attack = true
	attack_timer = 0
	obj.anim_next = "attack3"

func run(delta):
	obj.velo.x = lerp(obj.velo.x, 0, obj.DASH_DECAY)	
	obj.velo.y = 0

	obj.velo = obj.move_and_slide_with_snap( obj.velo,Vector2.DOWN, Vector2.UP )

	if first_attack and attack_timer > 0.2:
		first_attack = false
		obj.velo.x = obj.DASH_FORCE * obj.dir_cur * 0.2
		obj.velo = obj.move_and_slide_with_snap( obj.velo, Vector2(0,10), Vector2.UP )

		
	attack_timer += delta
	if attack_timer > 1.2:
		fsm.state_next = fsm.states.idle
