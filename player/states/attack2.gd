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
		if attack_timer > 0.5 and attack_timer < 1.1:
			fsm.state_next = fsm.states.attack3

	if first_attack and attack_timer > 0.1:
		# obj.attack_sound.play()
		first_attack = false
		obj.velo.x = obj.ATTACK_DISPLACE * obj.dir_cur * 0.1
		obj.velo = obj.move_and_slide_with_snap(obj.velo, Vector2(0,10), Vector2.UP)

	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if abs(dir) and attack_timer > 0.6:
		fsm.state_next = fsm.states.run
		return

	if Input.is_action_just_pressed("dash") and obj.can_dash() and attack_timer > 0.8:
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

	if attack_timer > 0.9:
		fsm.state_next = fsm.states.idle
