extends Control
class_name Menu

export var is_active = false

signal selected(selection_no)

onready var music = get_node("AudioStreamPlayer")

var confirm_audio = preload("res://assets/audio/ui/se_ok00.wav")
var change_audio = preload("res://assets/audio/ui/se_changeitem.wav")
var cancel_audio = preload("res://assets/audio/ui/se_cancel00.wav")

var selections = []
var unselectable = []
var cur_selection = 0

var selections_path = ""

func set_selections_path(v):
	selections_path = v

func _ready():
	if not is_active:
		set_physics_process(false)

func _physics_process(_delta):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("left"):
		change_fx()
		cur_selection -= 1
		if cur_selection < 0:
			cur_selection += selections.size()
		if unselectable.find(selections[cur_selection]) != -1:
			cur_selection -= 1
			if cur_selection < 0:
				cur_selection += selections.size()
		update_selection()

	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("right"):
		change_fx()
		cur_selection += 1
		if cur_selection >= selections.size():
			cur_selection -= selections.size()
		if unselectable.find(selections[cur_selection]) != -1:
			cur_selection += 1
			if cur_selection >= selections.size():
				cur_selection -= selections.size()
		update_selection()

	if Input.is_action_just_pressed("attack"):
		confirm_fx()
		emit_signal("selected", cur_selection)

func update_menu():
	selections = []
	unselectable = []
	for s in get_node(selections_path).get_children():
		selections.append(s)
		if s.selectable:
			s.show_selection()
		else:
			s.hide_selection()
			unselectable.append(s)
	selections[cur_selection].on_selected()

func update_selection():
	for i in range(selections.size()):
		if i == cur_selection:
			selections[i].on_selected()
		else:
			if unselectable.find(selections[i]) == -1:
				selections[i].de_selected()

func change_fx():
	music.stream = change_audio
	music.play()

func confirm_fx():
	music.stream = confirm_audio
	music.play()

func cancel_fx():
	music.stream = cancel_audio
	music.play()

func activate():
	is_active = true
	set_physics_process(true)
	set_process_input(true)
	cur_selection = 0
	update_selection()

func deactivate():
	is_active = false
	set_physics_process(false)
	set_process_input(false)
