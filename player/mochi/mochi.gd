extends VerletChain

var dir_cur = 1 setget _set_dir
var is_center : = false setget _set_center

export (float) var SWIM_SPEED = 20

onready var tween = $Tween

var youmu
var dir_to_Y
var distance_to_Y

var is_swimming

func _set_dir( v ):
	if dir_cur != v:
		dir_cur = v
		if not is_center:
			$anchor.position = Vector2( -1 * dir_cur, 1 )
		for loop in loops:
			loop.get_node( "Sprite" ).scale.x = dir_cur

func _set_center( v ):
	is_center = v
	if is_center:
		$anchor.position = Vector2( 0, 1 )
	else:
		$anchor.position = Vector2( -1 * dir_cur, 1 )

func _ready():
	Game.mochi = self
	is_swimming = false
	set_physics_process(false)
	randomize()

func setup():
	youmu = Game.player
	set_physics_process(true)

func _physics_process(_delta):
	dir_to_Y = youmu.global_position - self.global_position
	distance_to_Y = dir_to_Y.length()

	if distance_to_Y < 100 and not is_swimming:
		swim()
	if distance_to_Y >= 100:
		tween.remove_all()
		return_to_Y()


func swim():
	is_swimming = true
	var x = randi() % 200 - 100
	var y = randi() % 150 - 75

	var time = Vector2(x,y).length() / SWIM_SPEED

	tween.interpolate_property(self, "global_position:x",
		global_position.x, global_position.x + x, time,
		Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(self, "global_position:y",
		global_position.y, global_position.y + y, time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func return_to_Y():
	var x = randi() % 100 - 50
	var y = randi() % 100 - 75
	tween.interpolate_property(self, "global_position",
		global_position, youmu.global_position + Vector2(x,y), 2,
		Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	is_swimming = false


