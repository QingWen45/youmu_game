extends FSM_state

var sign_timer

func initialize():
	sign_timer = 0.0
	obj.anim_next = "idle"
	obj.create_danmaku(obj.phase - 1)

func run(delta):
	sign_timer += delta
	if sign_timer > 10.0:
		fsm.state_next = fsm.states.idle
