extends Menu

const START_MENU = "res://menu/start_menu/start_menu.tscn"

onready var item_menu = get_parent().get_node("item_menu")

func _ready():
	set_selections_path("margin/hbox/selections")
	update_menu()

	var _res = connect("selected", self, "on_selected")


func on_selected(selection_no):
	match selection_no:
		0:
			# continue
			Game.main.pause_finish()
		1:
			# items
			item_menu.show()
			self.deactivate()
			item_menu.activate()
		2:
			# load save
			hide()
			deactivate()

			Gamestate.load_gamestate()
			Game.hud.initialize()
			Game.item_menu.load_item()
			Game.item_menu.item_effect()

			Game.main.bgm_change("")
			Game.main.pause_finish()
			Game.main.load_save()
		3:
			# back title
			hide()
			deactivate()
			# Game.main.bgm_change(0)
			Game.hud.hide()
			Game.main.pause_finish()
			Game.main.load_screen(START_MENU)
		4: 
			# quit
			get_tree().quit()
