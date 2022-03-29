extends FSM_state

onready var tween = $Tween
var is_moving
var target_pos
var player_distance
var speed

var moving_timer

func initialize():
	moving_timer = 0
	is_moving = false
	obj.anim_next = "near"

func run(delta):
	if not is_moving:
		is_moving = true
		player_distance = obj.get_player_distance_h()
		speed = player_distance / 100
		# target_pos = obj.global_position.x + 50 * obj.dir_cur * speed
		target_pos = obj.global_position.x + (player_distance - 70) * obj.dir_cur
		tween.interpolate_property(obj, "global_position:x", obj.global_position.x, target_pos, 0.5 * speed, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	moving_timer += delta
	if moving_timer > 0.5 * speed:
		fsm.state_next = fsm.states.idle

func _on_Tween_tween_all_completed():
	pass
	# if fsm.state_cur == fsm.states.near:
		# fsm.state_next = fsm.states.idle
