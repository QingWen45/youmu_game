extends KinematicBody2D

var GRAVITY = 600
var MAX_FALL_SPEED = 600
var THROW_FORCE = 100
var DAMAGE = 10

export (bool) var is_hittable = false

var projectile_path = preload("res://enemy/nitori/projectile.tscn")

onready var sprite = $Sprite
onready var explosion_sp = $Explosion
onready var anim = $anim
onready var timer = $Timer

var is_bounced
var has_exploded
var velo


func _ready():
	timer.start(0.5)
	set_physics_process(false)
	is_bounced = false
	has_exploded = false

func initialize(dir: Vector2):
	velo = dir * THROW_FORCE
	velo.y -= 100

func _physics_process(delta):
	if not has_exploded:
		rotate(deg2rad(60 * delta))
		velo.y = min(MAX_FALL_SPEED, velo.y + GRAVITY * delta)
		velo = move_and_slide(velo, Vector2.UP)

func explode():
	var dir = velo
	velo = Vector2.ZERO
	sprite.hide()
	explosion_sp.show()
	anim.play("explode")

	for i in range(3):
		var projectile = projectile_path.instance()
	
		projectile.global_position = global_position
		projectile.initialize(dir.rotated(deg2rad(30 - i*30)).normalized())
		get_parent().add_child(projectile)
		projectile.set_physics_process(true)


func _on_Timer_timeout():
	has_exploded = true
	explode()

func _on_anim_animation_finished(name: String):
	if name == "explode":
		queue_free()
