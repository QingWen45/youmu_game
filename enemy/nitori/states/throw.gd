extends FSM_state

var throw_timer
var bomb_type
var throw_limit

func initialize():
	throw_timer = 0.0
	if obj.phase == 0:
		throw_limit = 1.0
	elif obj.phase == 1:
		throw_limit = 0.8
	elif obj.phase == 2:
		throw_limit = 0.7
	obj.anim_next = "throw"

func run(delta):
	throw_timer += delta
	if throw_timer > 1.0:
		fsm.state_next = fsm.states.idle

func on_throw():
	var dir = Vector2(obj.dir_cur ,-1).rotated(deg2rad(randi() % 10 - 20))
	if obj.phase == 0:
		bomb_type = 0
	elif obj.phase == 1:
		bomb_type = randi() % 2
	elif obj.phase == 2:
		var factor = randi() % 3
		if factor < 1:
			bomb_type = 0
		else:
			bomb_type = 1
	if bomb_type == 0:
		obj.throw(dir, bomb_type)
	else:
		obj.throw(dir, bomb_type, randi() % 2 + 2 + obj.phase)
