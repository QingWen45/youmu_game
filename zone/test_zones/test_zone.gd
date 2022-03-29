extends Level


onready var anim = $anim
onready var wall = $wall/shape
onready var event_shape = $boss_event/shape
onready var tween = $Tween
onready var timer = $Timer

onready var nitori = $nitori
onready var boss_pos = $boss_pos
onready var boss_limit_L = $boss_limit_L

var is_event_triggered

# Called when the node enters the scene tree for the first time.
func _ready():
	is_event_triggered = false
	call_deferred("connect_boss")

func connect_boss():
	var _res = Game.cur_boss.connect("boss_defeated", self, "_on_boss_defeated")

func _collider_disable():
	wall.disabled = false
	# $boss_event.queue_free()
	event_shape.disabled = true

func _collider_enable():
	wall.disabled = true
	event_shape.disabled = false


func _on_boss_defeated():
	pass

func _on_boss_event_body_entered(_body):
	if is_event_triggered:
		return
	else:
		is_event_triggered = true
	Game.player.fsm.state_next = Game.player.fsm.states.cutscene
	call_deferred("_collider_disable")

	timer.start(1)
	yield(timer, "timeout")

	tween.interpolate_property(nitori, "global_position", nitori.global_position, boss_pos.global_position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

	Gamestate.set_boss()
	Game.camera.limit_left = boss_limit_L.position.x
	Game.camera.limit_top = boss_limit_L.position.y

	timer.start(1)
	yield(timer, "timeout")

	nitori.activate()
	Game.player.fsm.state_next = Game.player.fsm.states.idle

