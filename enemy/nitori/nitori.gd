extends KinematicBody2D

#------------------------------
# get ready for the first boss!
#------------------------------

# warning-ignore: unused_signal
signal boss_defeated
signal danmanku_over

export (int) var GRAVITY = 300
export (float) var MAX_FALL_SPEED = 700
export (int) var MAX_HEALTH = 600
export (int) var MOVE_SPEED = 200
export (float) var SPEED_DECAY = 0.2
export (float) var DECISION_TIMER = 0.2
export (float) var ATTACK_DISPLACE = 400

var projectile_path = preload("res://enemy/nitori/projectile.tscn")
var BB_path = preload("res://enemy/nitori/big_bomb.tscn")
var bullet_path = preload("res://enemy/nitori/bullet.tscn")
var missile_path = preload("res://enemy/nitori/missile.tscn")
var smoke_path = preload("res://enemy/nitori/missile_smoke.tscn")

onready var fsm = FSM.new(self, $states, $states/idle)

onready var anim = $anim
onready var anim_fx = $anim_fx
onready var anim_fan = $rotator/fan/anim
onready var anim_float = $anim_float
onready var fan = $rotator/fan
onready var tween = $Tween
onready var project_pos = $rotator/projectile_pos
onready var timer = $Timer
onready var ray = $RayCast2D
onready var sprite = $rotator/Sprite

onready var takeoff_sound = $take_off

var anim_cur = ""
var anim_next = "idle"
var dir_cur = 1
var dir_next = 1

var velo = Vector2()
var is_stuned: bool

export(bool) var is_active = false
var player_dead = false
var phase = 0

# Enemy attributes ---
var boss_name = "Kawashiro Nitori"
var health = MAX_HEALTH
# --------------------

func _ready():
	if not is_active:
		deactivate()
	is_stuned = false
	Game.cur_boss = self

func _exit_tree():
	fsm.free()

func _physics_process(delta):
	fsm.run_machine(delta)

	if health < 2 * MAX_HEALTH / 3 and phase != 1:
		phase = 1
	if health < MAX_HEALTH / 3 and phase != 2:
		phase = 2

	if anim_cur != anim_next:
		anim_cur = anim_next
		anim.play(anim_cur)
	
	if dir_cur != dir_next:
		dir_cur = dir_next
		$rotator.scale.x = dir_cur

func activate():
	self.show()
	Game.player.connect("player_dead", self, "_on_player_dead")
	set_physics_process(true)

func deactivate():
	set_physics_process(false)

func get_player_distance_h():
	return abs(Game.player.global_position.x - global_position.x)

func get_player_direction():
	return sign(Game.player.global_position.x - global_position.x)

func create_danmaku(type):
	$charge.play()
	match type:
		# wave
		# end_pos
		#    |
		#    |
		# about 270px
		#    |
		#    V
		# start_pos
		0:
			var start_pos_L = get_parent().get_node("danmaku2").global_position
			var start_pos_R = get_parent().get_node("danmaku3").global_position
			var v_offset = 0
			var bullet
			var dir
			for _i in range(30):
				for _j in range(3):
					# left sine
					bullet = bullet_path.instance()
					dir = Vector2(1,0)
					bullet.initialize(dir, 0, v_offset)
					get_parent().add_child(bullet)
					bullet.global_position = start_pos_L
					bullet.global_position.y -= v_offset
					# left sine2
					bullet = bullet_path.instance()
					dir = Vector2(1,0)
					bullet.initialize(dir, 2, v_offset)
					get_parent().add_child(bullet)
					bullet.global_position = start_pos_L
					bullet.global_position.y -= v_offset
					#right sine
					bullet = bullet_path.instance()
					dir = Vector2(-1,0)
					bullet.initialize(dir, 0, v_offset)
					get_parent().add_child(bullet)
					bullet.global_position = start_pos_R
					bullet.global_position.y -= v_offset
					#right sine2
					bullet = bullet_path.instance()
					dir = Vector2(-1,0)
					bullet.initialize(dir, 2, v_offset)
					get_parent().add_child(bullet)
					bullet.global_position = start_pos_R
					bullet.global_position.y -= v_offset
					v_offset += 120
				if _i % 5 == 0:
					$dan.play()
					timer.start(0.6)
				else:
					timer.start(0.2)
				yield(timer, "timeout")
				v_offset = 0
			emit_signal("danmanku_over")
				
		# water fall
		# start_pos ----about 660 px ---> end_pos
		1:
			var start_pos = get_parent().get_node("danmaku1").global_position
			var h_offset = 0
			var bullet
			for _i in range(10):
				for _j in range(24):
					bullet = bullet_path.instance()
					var dir = Vector2(0,1).rotated(deg2rad(randi() % 40))
					bullet.initialize(dir, 1)
					h_offset += randi() % 60
					get_parent().add_child(bullet)
					bullet.global_position = start_pos
					bullet.global_position.x += h_offset
					
					timer.start(0.1)
					yield(timer, "timeout")
					if _j % 4 == 0:
						$dan.play()
				h_offset = 0
				
			emit_signal("danmanku_over")

func throw(dir: Vector2, type: int, c_num = 3):
	$throw.play()
	var projectile
	match type:
		0:
			projectile = projectile_path.instance()
			projectile.is_hittable = true
			projectile.initialize(dir)
		1:
			projectile = BB_path.instance()
			projectile.initialize(dir, c_num)
	
	get_parent().add_child(projectile)
	projectile.global_position = project_pos.global_position
	projectile.set_physics_process(true)

func cannon_fire(spread = 0):
	$fire.play()
	var missile = missile_path.instance()
	var smoke = smoke_path.instance()

	missile.initialize(dir_cur, spread)
	get_parent().add_child(missile)
	get_parent().add_child(smoke)
	missile.global_position = project_pos.global_position
	missile.global_position.y += randi() % 10 - 5
	smoke.global_position = project_pos.global_position + Vector2(20, 0) * dir_cur
	smoke.scale.x = dir_cur
	missile.set_physics_process(true)

	velo.x = ATTACK_DISPLACE * -dir_cur

func hurt(area, damage):
	if area.name != "player":
		$hurt.play()
		health -= damage
		Gamestate.boss_health_change()
		stop_all_tween()
		fsm.state_next = fsm.states.hurt
	if not is_stuned:
		return
	$hurt.play()
	health -= damage
	Gamestate.boss_health_change()
	if health <= 0:
		emit_signal("boss_defeated")
		$down.play()
		Game.main.bgm_change("")
		fsm.state_next = fsm.states.dead
	else:
		anim_fx.play("hurt")

func stop_all_tween():
	$states/away/Tween.stop_all()
	$states/near/Tween.stop_all()

func disable_collider():
	$hurtbox/collider.disabled = true
	$physic_shape.disabled = true

func _on_player_dead():
	player_dead = true
