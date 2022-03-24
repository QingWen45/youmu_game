extends Menu


func _ready():
	set_selections_path("margin/panel/vbox/selections")
	update_menu()
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("quit"):
		cancel_fx()
		emit_signal("selected", 1)
		set_visible(false)
		set_process_input(false)