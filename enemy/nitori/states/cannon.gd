extends FSM_state

onready var timer = $Timer
var BASE_MISSILE_NUM = 3

func initialize():
	obj.anim_next = "cannon_up"


func run(_delta):
	obj.velo.x = lerp(obj.velo.x, 0, obj.SPEED_DECAY)
	obj.velo = obj.move_and_slide( obj.velo)

func fire(n):
	var spread = 30 * (obj.phase + 1)
	obj.anim_next = "fire"
	for _i in range(n):
		obj.cannon_fire(spread)
		timer.start(0.1)
		yield(timer, "timeout")
	obj.anim_next = "cannon_down"
	
	timer.start(0.7)
	yield(timer, "timeout")
	if fsm.state_cur == fsm.states.cannon:
		fsm.state_next = fsm.states.idle

func _on_animation_end():
	fire(randi() % 2 + obj.phase + BASE_MISSILE_NUM)