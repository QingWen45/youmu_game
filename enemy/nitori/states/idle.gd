extends FSM_state

var idle_timer
var player_distance
var target_pos
var has_dan_1 = false
var has_dan_2 = false

func initialize():
	idle_timer = obj.DECISION_TIMER
	obj.anim_next = "idle"

func run(delta):
	if obj.player_dead: return

	obj.dir_next = obj.get_player_direction()

	if idle_timer > 0:
		idle_timer -= delta

	else:
		idle_timer = obj.DECISION_TIMER
		player_distance = obj.get_player_distance_h()
	
		if player_distance > 180 :
			fsm.state_next = fsm.states.near
			return
	
		elif player_distance < 70:
			fsm.state_next = fsm.states.away
			return
		
		else:
			var dicision_factor = randi() % 10
			if obj.phase == 0:
				if dicision_factor <= 6:
					fsm.state_next = fsm.states.throw
				else:
					fsm.state_next = fsm.states.cannon
			elif obj.phase == 1:
				if not has_dan_1:
					has_dan_1 = true
					fsm.state_next = fsm.states.sign
					return
				if dicision_factor <= 7:
					fsm.state_next = fsm.states.throw
				else:
					fsm.state_next = fsm.states.cannon
			elif obj.phase == 2:
				if not has_dan_2:
					has_dan_2 = true
					fsm.state_next = fsm.states.sign
					return
				if dicision_factor <= 7:
					fsm.state_next = fsm.states.throw
				else:
					fsm.state_next = fsm.states.cannon
				
