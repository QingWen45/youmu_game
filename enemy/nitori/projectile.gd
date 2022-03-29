extends KinematicBody2D

var GRAVITY = 600
var MAX_FALL_SPEED = 600
var THROW_FORCE = 100
var DAMAGE = 10

export (bool) var is_hittable = false

onready var sprite = $Sprite
onready var explosion_sp = $Explosion
onready var anim = $anim
onready var timer = $Timer

onready var explo_shape = $hitbox/shape
onready var counter_hit_shape = $hitbox2/shape

var is_bounced
var has_exploded
var velo

func _ready():
	set_physics_process(false)
	is_bounced = false
	has_exploded = false

func initialize(dir: Vector2):
	velo = dir * THROW_FORCE
	velo.y -= 100

func _physics_process(delta):
	if not has_exploded:
		if not is_bounced:
			velo.y = min(MAX_FALL_SPEED, velo.y + GRAVITY * delta)
		velo = move_and_slide(velo, Vector2.UP)

		if is_on_floor():
			has_exploded = true
			explode()

func explode():
	velo = Vector2.ZERO
	sprite.hide()
	explosion_sp.show()
	anim.play("explode")
	$explode.play()

func _on_anim_animation_finished(name: String):
	if name == "explode":
		queue_free()

# explodes and hurt the player
func _on_hitbox_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

# explodes and hurt the boss
func _on_hitbox2_area_entered(area):
	explode()
	area.emit_signal("hurt", self, DAMAGE)

# when the bomb is hit
# this method can be disabled
func _on_hurtbox_area_entered(_area):
	if not is_hittable:
		return

	is_bounced = true
	velo = Vector2.ZERO
	timer.start(0.1)
	yield(timer, "timeout")

	counter_hit_shape.disabled = false
	var rel_dir = Game.cur_boss.global_position - global_position
	rel_dir = rel_dir.normalized()
	velo = rel_dir * 500