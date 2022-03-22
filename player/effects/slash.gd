extends Area2D

var dir = 1
var damage
var is_hit

export (float) var BULLET_SPEED = 500

onready var anim = $AnimationPlayer

func initialize(d):
	is_hit = false
	dir = d
	self.scale.x = d
	position.x += 20 * d

func _physics_process(delta):
	if not is_hit:
		position.x += BULLET_SPEED * delta * dir

func _on_slash_area_entered(_area):
	is_hit = true
	anim.play("leave")

func _on_slash_body_entered(_body):
	is_hit = true
	anim.play("leave")


func _on_VisibilityNotifier2D_screen_exited():
	anim.play("leave")
