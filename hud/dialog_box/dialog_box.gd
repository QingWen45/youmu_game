extends Control

# warning-ignore: unused_signal
signal dialog_finished
signal line_finished

onready var name_label = $vbox/hbox/name_label
onready var dialog_label = $vbox/dialog_label
onready var tween = $Tween
onready var timer = $Timer
onready var arrow = $arrow
onready var anim = $anim 

var is_line_finished: bool
# interact 0
# delay 1
var type

func _ready():
	type = 0
	modulate.a = 0.0
	set_process_input(false)
	arrow.hide()
	is_line_finished = false

func _input(_event):
	# dialog quick end
	if Input.is_action_just_pressed("interact") and not is_line_finished:
		tween.seek(tween.get_runtime() - 0.01)

	# to next line
	if Input.is_action_just_pressed("interact") and is_line_finished:
		arrow.hide()
		anim.stop(true)

		emit_signal("line_finished")

# ------------------------------
# Dialog box's main method
# give the name and the array of dialogs in String
# ------------------------------
func show_message(speaker: String, msgs: Array, duration = 1.0):
	type = 0
	name_label.text = speaker + ":"
	# var dialog_num = msgs.size()

	# stop the movement of the player
	Game.player.fsm.state_next = Game.player.fsm.states.cutscene

	# revail the box
	if modulate.a == 0.0:
		tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	yield(tween, "tween_all_completed")

	set_process_input(true)

	# var index = 0
	for msg in msgs:
		# typer effect
		dialog_label.text = msg
		tween.interpolate_property(dialog_label, "percent_visible", 0.0, 1.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(self, "line_finished")

	set_process_input(false)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	Game.player.fsm.state_next = Game.player.fsm.states.idle
	yield(tween, "tween_all_completed")
	emit_signal("dialog_finished")

func show_delay_message(speaker: String, msg: String, duration = 1.0):
	modulate.a = 0.0
	type = 1
	name_label.text = speaker + ":"
	# var dialog_num = msgs.size()

	# revail the box
	if modulate.a == 0.0:
		tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	yield(tween, "tween_all_completed")

	timer.start(duration)
	dialog_label.text = msg
	tween.interpolate_property(dialog_label, "percent_visible", 0.0, 1.0, duration*0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
		
	yield(timer, "timeout")
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	Game.player.fsm.state_next = Game.player.fsm.states.idle
	yield(tween, "tween_all_completed")
	emit_signal("dialog_finished")


func _on_Tween_tween_completed(_object, key):
	if str(key) == ":percent_visible" and type == 0:
		arrow.show(true)
		anim.play("arrow")
		is_line_finished = true
	
