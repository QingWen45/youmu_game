extends FSM_state

onready var tween = $Tween

func initialize():
	obj.anim_next = "take_off"
	obj.anim_fan.play("run")
	obj.fan.show()
	obj.anim_float.play("float")
	var target_pos = obj.get_parent().get_node("boss_pos").global_position.y
	tween.interpolate_property(obj, "global_position:y", obj.global_position.y, target_pos,
		 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	fsm.state_next = fsm.states.idle


func run(_delta):
	pass
	

