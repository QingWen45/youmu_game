extends Node2D

const START_MENU = "res://menu/start_menu/start_menu.tscn"

onready var load_anim = $load_layer/load_anim
onready var hud = $hud_layer/hud
onready var pause = $pause_layer/pause_menu
onready var black_layer = $black_layer/ColorRect
onready var screen_timer = $scrn_timer
onready var save_timer = $save_timer
onready var bgm_player = $bgm
onready var tween = $Tween

var is_paused = false

func _ready():
	Game.main = self
	hud.hide()
	load_screen(START_MENU)


#------------------------
# load phase
# 0: screen fade black
# 1: free old screen
# 2: load new screen
# 3: screen fade back
#------------------------

var load_phase = 0
var cur_scrn
func load_screen(scrn:String = ""):
	if not scrn.empty():
		load_phase = 0
		cur_scrn = scrn
	match load_phase:
		0:
			load_anim.play("fade_in")
			
			load_phase = 1
			screen_timer.start(0.2)
		1:
			var old_level = $level.get_children()
			if not old_level.empty():
				old_level[0].queue_free()

			load_phase = 2
			screen_timer.start(0.1)
		2:	
			var new_level = load(cur_scrn).instance()
			$level.add_child(new_level)

			load_phase = 3
			screen_timer.start(0.3)
		3:
			load_anim.play("fade_out")
			
			load_phase = 4
			screen_timer.start(0.2)

		4:
			load_phase = 0

func _on_scrn_timer_timeout():
	load_screen()


func load_save():
	match load_phase:
		0:
			load_anim.play("fade_in")
			
			load_phase = 1
			save_timer.start(0.2)
		1:
			var old_level = $level.get_children()
			if not old_level.empty():
				old_level[0].queue_free()

			load_phase = 2
			save_timer.start(0.1)
		2:	
			hud.show()
			var new_level = load(Gamestate.state.current_level).instance()
			$level.add_child(new_level)
			if Game.player:
				Game.player.fsm.state_next = Game.player.fsm.states.cutscene

			load_phase = 3
			save_timer.start(0.3)
		3:
			load_anim.play("fade_out")
			
			load_phase = 4
			save_timer.start(0.2)

		4:
			if Game.player:
				Game.player.fsm.state_next = Game.player.fsm.states.idle
			load_phase = 0

func _on_save_timer_timeout():
	load_save()


func bgm_change(): # ( music:String = ""):
	pass


func _input(event):
	if event.is_action_pressed("quit"):
		if is_paused:
			pause_finish()
		else:
			pause_game()


func pause_game():
	# play the music for pause
	$pause_layer.get_node("pause").play()
	is_paused = true
	pause.show()
	pause.activate()
	get_tree().paused = true

func pause_finish():
	pause.hide()
	pause.deactivate()
	is_paused = false
	get_tree().paused = false
