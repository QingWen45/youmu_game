extends Area2D

export (int) var DAMAGE = 10
export (float) var SPEED = 100

var WAVE_CYCLE = 0.01
var WAVE_HEIGHT = 64
onready var timer = $Timer

var velo: Vector2
# sine 0
# linear 1
# sine 2
var type = 1
var v_offset

func _ready():
	match type:
		1:
			timer.start(1.2)
			yield(timer, "timeout")
			velo *= 0.05
			timer.start(5.0)
			yield(timer, "timeout")
			velo *= 30

func initialize(dir, b_type, verticle_offset = 0):
	type = b_type
	velo = dir * SPEED
	v_offset = verticle_offset

func _physics_process(delta):
	match type:
		0:
			position.x += velo.x * delta
			position.y = sin(WAVE_CYCLE * position.x) * WAVE_HEIGHT - v_offset
		1: 
			position += velo * delta
		2:
			position.x += velo.x * delta
			position.y = sin(WAVE_CYCLE * position.x + PI) * WAVE_HEIGHT - v_offset


func _on_bullet_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
