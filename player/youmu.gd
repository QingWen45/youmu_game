extends KinematicBody2D

var _debug = false

# Constants
export (int) var GRAVITY =1200
export (int) var SNAP_LEN = 30

export (float) var JUMP_FORCE = -500
export (float) var DASH_FORCE = 1200
export (float) var DASH_DURATION = 0.15
export (float) var DASH_DECAY = 0.2
export (float) var DASH_GAP = 1
export (float) var MAX_SPEED = 180
export (float) var MAX_FALL_SPEED = 700
export (float) var AIR_ACCEL = 0.2
export (float) var JUMP_MARGIN = 0.2
export (float) var JUMP_AGAIN_TIME = 0.2
export (float) var DAMAGE = 10

# instance finate state machine
onready var fsm = FSM.new(self, $states, $states/idle, _debug)
onready var VISUAL_STAY = preload("res://scripts/visual_stay/visual_stay.tscn")

onready var anim = $anim
onready var anim_fx = $animfx

onready var sprite = $rotator/player
onready var dash_timer = $dash_timer

var jump_dust = preload("res://player/effects/jump_dust.tscn")

var anim_cur = ""
var anim_next = "idle"
var dir_cur = 1
var dir_next = 1

var is_invulnerable = false
var invulnerable_timer = 0.0

var has_double_jumped : bool = false

var visual_stay
var velo = Vector2()

onready var step_mp = $step

# warning-ignore: unused_signal
signal player_dead

func _ready():
	visual_stay_ready()
	Game.player = self
	Game.mochi.setup()

func _exit_tree():
	fsm.free()
	visual_stay.queue_free()

func _physics_process(delta):
	fsm.run_machine(delta)

	if anim_cur != anim_next:
		# if _debug:
			# print("Changing anim to ",anim_next)	
		anim_cur = anim_next
		anim.play(anim_cur)
	
	if dir_cur != dir_next:
		dir_cur = dir_next
		$rotator.scale.x = dir_cur

	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false

# apply a force towards up
func jump():
	velo.y = JUMP_FORCE
	velo += get_floor_velocity()
	velo = move_and_slide(velo, Vector2.UP)

func can_be_hit() -> bool:
	if fsm.state_cur == fsm.states.hurt:
		return false
	if fsm.state_cur == fsm.states.dash:
		return false
	if fsm.state_cur == fsm.states.dead:
		return false
	if is_invulnerable:
		return false
	return true

func jump_dust_generate(v_offset):
	var d = jump_dust.instance()
	# generate under feet
	d.position = position + Vector2(0, v_offset)
	get_parent().add_child(d)

func hurt(area, damage):
	if not can_be_hit():
		return

	Game.camera.shake(2, 0.3)
	
	var hurt_dir = global_position - area.global_position
	Gamestate.player_hurt(Gamestate.state.health - damage, Gamestate.state.health)
	velo = hurt_dir.normalized() * 200
	velo = move_and_collide(Vector2(velo.x, 0))
	if Gamestate.state.health == 0:
		fsm.state_next = fsm.states.dead
	else:
		fsm.state_next = fsm.states.hurt

func visual_stay_ready():
	visual_stay = VISUAL_STAY.instance()
	visual_stay.initialize(sprite)
	get_parent().call_deferred("add_child", visual_stay)

func vs_create():
	visual_stay.bang(sprite.frame, dir_cur, global_position + Vector2(20 * dir_cur,0))

func dash():
	dash_timer.start(DASH_GAP)
	velo.x = DASH_FORCE * dir_cur
	# velo += get_floor_velocity()
	velo = move_and_slide(velo, Vector2.UP)

func can_dash():
	return dash_timer.is_stopped()

# create!
func graze_effect_create(v, max_v):
	pass


func _on_graze_area_exited(area):
	pass

func _on_hitbox_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_hitbox1_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE * 2)

func _on_hitbox2_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE * 5)

func _on_death_timer_timeout():
	pass
