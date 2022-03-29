extends FSM_state

# spicify whether it's a charge atk or a normal one
const CHARGE_JUDGE_FACTOR = 0.1
var charge_judge = 0
var is_first_attack
# spicify whether to enter attack phase 2
var attack_timer = 0

var first_attack

func initialize():
	is_first_attack = true
	first_attack = true
	attack_timer = 0
	charge_judge = CHARGE_JUDGE_FACTOR
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
		if attack_timer > 0.4 and attack_timer < 0.8:
			fsm.state_next = fsm.states.attack2

	if first_attack and attack_timer > 0.1:
		# obj.attack_sound.play()
		first_attack = false
		obj.velo.x = obj.ATTACK_DISPLACE * obj.dir_cur * 0.2
		obj.velo = obj.move_and_slide_with_snap( obj.velo, Vector2(0,10), Vector2.UP )

	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if abs(dir) and attack_timer > 0.5:
		fsm.state_next = fsm.states.run
		return

	if Input.is_action_just_pressed("dash") and obj.can_dash() and attack_timer > 0.8:
		obj.dash()
		fsm.state_next = fsm.states.dash
		return

	if attack_timer > 0.7:
		fsm.state_next = fsm.states.idle
