extends Area2D

var DAMAGE = 10
var SPEED = 300
var STEER_FORCE = 50.0

onready var sprite = $Sprite
onready var explosion_sp = $Explosion
onready var anim = $anim
onready var timer = $Timer

onready var explo_shape = $hitbox/shape

var has_exploded = false
var is_seeking = false
var velo = Vector2.ZERO
var accel = Vector2.ZERO
var target

func _ready():
	set_physics_process(false)
	has_exploded = false
	is_seeking = false

	timer.start(0.2)
	yield(timer, "timeout")
	is_seeking = true
	
	timer.start(1.0)
	yield(timer, "timeout")
	is_seeking = false


func initialize(dir: int, spread = 0):
	target = Game.player
	velo = Vector2.RIGHT * SPEED * dir
	if spread:
		var to_rotate = deg2rad(randi() % (2*spread) - spread)
		rotate(to_rotate)
		velo = velo.rotated(to_rotate)
	if dir == -1:
		rotate(deg2rad(180))
	

func seek():
	var steer = Vector2()
	var disired_pos = (target.global_position - global_position).normalized() * SPEED
	steer = (disired_pos - velo).normalized() * STEER_FORCE
	return steer


func _physics_process(delta):
	if has_exploded:
		return
	if is_seeking:
		accel += seek()
		velo += accel * delta
		velo = velo.clamped(SPEED)
		rotation = velo.angle()
	position += velo * delta

func explode():
	rotation = 0
	has_exploded = true
	$Particles2D.emitting = false
	set_physics_process(false)
	velo = Vector2.ZERO
	sprite.hide()
	explosion_sp.show()
	anim.play("explode")

func _on_anim_animation_finished(name: String):
	if name == "explode":
		queue_free()

# explodes and hurt the player
func _on_hitbox_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_missile_area_entered(_area):
	explode()

func _on_missile_body_entered(_body):
	explode()
