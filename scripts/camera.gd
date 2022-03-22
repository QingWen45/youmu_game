extends Camera2D
class_name MainCamera

onready var tween = Tween.new()

func _ready():
	Game.camera = self
	add_child(tween)

func offset(strength: float):
	offset_h = rand_range(-strength, strength)
	offset_v = rand_range(-strength, strength)


func shake(strength: float, duration: float):
	tween.interpolate_method(self, "offset", strength, 0, duration, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	tween.start()