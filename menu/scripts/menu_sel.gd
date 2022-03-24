extends Label

export(bool) var selectable = true

onready var loop_anim = $loop

func show_selection():
	modulate.a = 1.0

func hide_selection():
	modulate.a = 0.5

func on_selected():
	loop_anim.play("selected")

func de_selected():
	loop_anim.play("default")
