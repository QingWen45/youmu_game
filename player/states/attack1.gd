extends FSM_state

# spicify whether it's a charge atk or a normal one
var charge_judge = 0
var is_first_attack
# spicify whether to enter attack phase 2
var attack_timer = 0

func initialize():
	is_first_attack = true
	attack_timer = 0
	charge_judge = 0.1
	obj.anim_next = "attack1"

func run(delta):
	if charge_judge > 0:
		charge_judge -= delta
	else:
		is_first_attack = false

	if is_first_attack and charge_judge <=0:
		if Input.is_action_pressed("attack"):
			fsm.state_next = fsm.states.charge

	obj.velo.x = 0
	obj.velo.y = 0

	obj.velo = obj.move_and_slide_with_snap( obj.velo, Vector2(0,10), Vector2.UP )

	attack_timer += delta
	if Input.is_action_just_pressed("attack"):
		if attack_timer > 0.5 and attack_timer < 0.8:
			fsm.state_next = fsm.states.attack2

	if attack_timer > 0.8:
		fsm.state_next = fsm.states.idle
