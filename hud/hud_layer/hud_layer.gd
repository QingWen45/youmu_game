extends Control

onready var health_bar = $margin/bars/left_hud/health_cover/health_bar
onready var damage_bar = $margin/bars/left_hud/health_cover/damage_bar
onready var msg_lb = $margin/bars/left_hud/hbox/Label

onready var boss_bar = $margin/bars/right_hud/boss_cover/boss_bar
onready var boss_hud = $margin/bars/right_hud
onready var boss_lb = $margin/bars/right_hud/hbox/Label

onready var debug_lb = $margin/bars/left_hud/debug

onready var side_msg_lb = $margin/side_msg/vbox/Label
onready var side_msg_tween = $margin/side_msg/vbox/Tween
onready var side_msg_timer = $margin/side_msg/vbox/Timer

onready var tween = $Tween
onready var tween2 = $Tween2

var _res

var refresh_time = 1.0

var boss_max_health
var boss_health
var health_temp

func _ready():
	# initialize()
	Game.hud = self
	_res = Gamestate.connect("player_hurt", self, "on_player_hurt")
	_res = Gamestate.connect("player_health_changed", self, "on_health_change")
	_res = Gamestate.connect("player_max_health_changed", self, "on_max_health_change")

	_res = Gamestate.connect("boss_ready", self, "get_boss_ready")
	_res = Gamestate.connect("boss_health_changed", self, "on_boss_health_change")
	_res = Gamestate.connect("boss_clear", self, "on_boss_clear")
	
func _process(delta):
	if Game._debug:
		if refresh_time > 0:
			refresh_time -= delta
		else:
			refresh_time = 1.0
			update_debug()
			

func update_debug():
	var other = ""
	if Gamestate.state.health > 60:
		other = "test version"
	elif Gamestate.state.health > 30:
		other = "health low"
	else:
		other = "quite danger"
	var msg = """
	Debug message:
health: {h}
fps: {fps}
{other}""".format({"h": Gamestate.state.health,
"hb": health_bar.value,
"fps": Engine.get_frames_per_second(),
"other": other})
	debug_lb.text = msg

func initialize():
	side_msg_lb.text = ""
	health_bar.value = Gamestate.state.max_health
	damage_bar.value = Gamestate.state.max_health
	health_bar.max_value = Gamestate.state.max_health
	damage_bar.max_value = Gamestate.state.max_health
	boss_hud.modulate.a = 0.0

# show text at side msg area
func show_text(msg: String = ""):
	side_msg_lb.percent_visible = 0.0
	side_msg_lb.text = msg
	side_msg_tween.interpolate_property(side_msg_lb, "percent_visible", 0.0, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	side_msg_tween.start()
	
	side_msg_timer.start(5.0)
	yield(side_msg_timer, "timeout")
	side_msg_tween.interpolate_property(side_msg_lb, "percent_visible", 1.0, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	side_msg_tween.start()

func on_player_hurt(v):
	health_bar.value = Gamestate.state.health
	tween.interpolate_property(damage_bar, "value", v, Gamestate.state.health, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func on_health_change():
	health_bar.value = Gamestate.state.health

func get_boss_ready():
	boss_lb.text = Game.cur_boss.boss_name
	boss_max_health = Game.cur_boss.MAX_HEALTH
	boss_bar.value = 0
	boss_bar.max_value = boss_max_health
	tween2.interpolate_property(boss_hud, "modulate:a", 0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()
	yield(tween2, "tween_all_completed")
	tween2.interpolate_property(boss_bar, "value", 0, boss_max_health, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()

func on_boss_health_change():
	var health = Game.cur_boss.health
	if health < 0:
		health = 0
	# print("health: ", health)
	boss_bar.value = health

func on_boss_clear():
	tween2.interpolate_property(boss_hud, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()
