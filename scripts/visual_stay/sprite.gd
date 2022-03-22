extends Sprite


func _ready():
	hide()

func get_ready(t, h, v):
	self.texture = t
	self.hframes = h
	self.vframes = v

func bang(f, s):
	show()
	self.frame = f
	self.scale.x = s
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
