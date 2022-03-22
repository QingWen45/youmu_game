extends FSM_state

# spicify whether to enter attack phase 3
var attack_timer = 0
var first_attack

func initialize():
	first_attack = true
	attack_timer = 0
	obj.anim_next = "attack2"

func run(delta):
	obj.velo.x = lerp(obj.velo.x, 0, obj.DASH_DECAY)	
	obj.velo.y = 0

	obj.velo = obj.move_and_slide_with_snap( obj.velo, Vector2(0,10), Vector2.UP )

	attack_timer += delta
	if Input.is_action_just_pressed("attack"):
		if attack_timer > 0.8 and attack_timer < 1.3:
			fsm.state_next = fsm.states.attack3

	if first_attack and attack_timer > 0.3:
		first_attack = false
		obj.velo.x = obj.DASH_FORCE * obj.dir_cur * 0.1
		obj.velo = obj.move_and_slide_with_snap(obj.velo, Vector2(0,10), Vector2.UP)

	if attack_timer > 1.2:
		fsm.state_next = fsm.states.idle
