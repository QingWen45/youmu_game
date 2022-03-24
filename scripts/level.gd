extends Node
class_name Level

var can_pause = true

func _ready():
	call_deferred( "_set_player" )
	call_deferred( "_set_camera" )

func _set_player():
	var player = Game.player
	var mochi = Game.mochi
	# print(Gamestate.state.current_pos)
	if not Gamestate.state.current_pos.empty():
		var start_pos = find_node(Gamestate.state.current_pos)
		player.global_position = start_pos.global_position
		mochi.global_position = start_pos.global_position + Vector2(40, 40)
		player.dir_next = Gamestate.state.current_dir
	else:
		var start_pos = find_node("initial_position")
		player.global_position = start_pos.global_position
		mochi.global_position = start_pos.global_position + Vector2(40, 40)
		player.dir_next = Gamestate.state.current_dir

func _set_camera():
	var camera = Game.camera
	var pos_l = find_node("camera_limit_L")
	var pos_r = find_node("camera_limit_R")
	camera.limit_left = pos_l.position.x
	camera.limit_top = pos_l.position.y
	camera.limit_right = pos_r.position.x
	camera.limit_bottom = pos_r.position.y
