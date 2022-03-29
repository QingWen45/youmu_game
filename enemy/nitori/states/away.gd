extends FSM_state

onready var tween = $Tween
var is_moving
var moving_timer
var target_pos

func initialize():
	moving_timer = 0.0
	is_moving = false
	obj.anim_next = "away"

func run(delta):
	if not is_moving:
		is_moving = true
		target_pos = obj.global_position.x + 70 * -obj.dir_cur
		tween.interpolate_property(obj, "global_position:x", obj.global_position.x, target_pos, 0.4, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

	moving_timer += delta
	if moving_timer > 0.4:
		fsm.state_next = fsm.states.idle

func _on_Tween_tween_all_completed():
	pass
	# if fsm.state_cur == fsm.states.away:
		# fsm.state_next = fsm.states.idle
