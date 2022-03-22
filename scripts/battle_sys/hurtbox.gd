extends Area2D

# warning-ignore: unused_signal
signal hurt(area, damage)

func _ready():
	var _res = connect("hurt", get_parent(), "hurt")
