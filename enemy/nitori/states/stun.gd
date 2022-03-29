extends FSM_state

var stun_timer

func initialize():
	stun_timer = 0.0
	obj.anim_next = "stun"
	obj.is_stuned = true

func run(delta):
	stun_timer += delta
	if stun_timer > 4.0 and obj.is_stuned:
		obj.is_stuned = false
		obj.anim_next = "stun_back"
	if stun_timer > 5.2:
		fsm.state_next = fsm.states.take_off

