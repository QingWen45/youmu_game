extends Control

export (bool) var is_active = false

onready var items = $margin/panel/margin2/split/items.get_children()
onready var name_lb = $margin/panel/margin2/split/description/name
onready var des_lb = $margin/panel/margin2/split/description/des

onready var pause_menu = get_parent().get_node("pause_menu")

var item_cur = 0
var item_next = 0

const ITEMS_PER_LINE = 6

func _ready():
	Game.item_menu = self
	if not is_active:
		self.deactivate()
	
	# load_item()
	_initialize()

func _input(event):
	if event.is_action_pressed("up"):
		item_next += ITEMS_PER_LINE
		if item_next >= items.size():
			item_next -= items.size()
		update_items()
	if event.is_action_pressed("down"):
		item_next -= ITEMS_PER_LINE
		if item_next < 0:
			item_next += items.size()
		update_items()
	if event.is_action_pressed("left"):
		item_next -= 1
		if item_next < 0:
			item_next += items.size()
		update_items()
	if event.is_action_pressed("right"):
		item_next += 1
		if item_next >= items.size():
			item_next -= items.size()
		update_items()
	if event.is_action_pressed("quit"):
		$AudioStreamPlayer2.play()
		self.hide()
		self.deactivate()
		pause_menu.activate()

func update_items():
	$AudioStreamPlayer.play()
	if item_cur != item_next:
		items[item_cur].deselect()
		items[item_next].select()
		name_lb.text = items[item_next].get_name()
		des_lb.text = items[item_next].get_description()
		item_cur = item_next

# -----------
# check the save and resume unlocked items in save
# -----------
func load_item():
	for i in range(items.size()):
		if Gamestate.state.items.has(items[i].item_no):
			items[i].unlock()
		else:
			items[i].lock()


# -----------
# this method shall be called only once per Game
# -----------
# current called in
# start_menu._ready() if not first start
# start_menu.start_new_game()
# -----------
func item_effect():
	print("item_effected")
	for i in Gamestate.state.items:
		items[i].effect()

func _initialize():
	for i in items:
		i.deselect()
	items[0].select()
	name_lb.text = items[0].get_name()
	des_lb.text = items[0].get_description()

func activate():
	is_active = true
	set_physics_process(true)
	set_process_input(true)

func deactivate():
	is_active = false
	set_physics_process(false)
	set_process_input(false)


