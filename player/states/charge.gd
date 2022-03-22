extends FSM_state

var charge_timer
var charge_ready
var base_charge_time = 0.8

func initialize():
	charge_ready = false
	charge_timer = 0.0
	obj.anim_next = "charge_ready"

func run(delta):
	if not charge_ready:
		charge_timer += delta

	if charge_timer > base_charge_time:
		obj.sprite.material.set_shader_param("aura_width", 3.0)
		obj.sprite.material.set_shader_param("aura_color", Vector3(1.0,0.0,0.0))

	if charge_timer > base_charge_time + 0.1:
		obj.sprite.material.set_shader_param("aura_width", 2.0)
		obj.sprite.material.set_shader_param("aura_color", Vector3(0.8,0.0,0.0))

	if charge_timer > base_charge_time + 0.2:
		charge_ready = true
		obj.sprite.material.set_shader_param("aura_width", 1.0)
		obj.sprite.material.set_shader_param("aura_color", Vector3(0.6,0.0,0.0))

	if Input.is_action_just_released("attack"):
		if charge_timer > 1:
			obj.velo.x = obj.DASH_FORCE * obj.dir_cur
			obj.velo = obj.move_and_slide(obj.velo, Vector2.UP)
			fsm.state_next = fsm.states.charge_attack
		else:
			fsm.state_next = fsm.states.attack1
	

func terminate():
	obj.sprite.material.set_shader_param("aura_color", Vector3(0,0,0))
	
