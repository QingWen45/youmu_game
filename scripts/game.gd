extends Node

# warning-ignore:unused_class_variable
var player = null
var mochi = null
var cur_boss = null
var camera = null
var main = null
var hud = null
var item_menu = null
# true to show debug messages
var _debug = true

# works when pausing the game
func _ready():
	randomize()
	self.pause_mode = PAUSE_MODE_PROCESS

var is_fullscreen = false
var window_size = Vector2()
var window_pos = Vector2()

func _input(_event):
	# changing the game window to fullscreen
	if Input.is_action_just_pressed("fullscreen"):
		if not is_fullscreen:
			# remember the original size and position for recovery
			OS.set_borderless_window(true)
			window_size = OS.window_size
			OS.set_window_size(OS.get_screen_size())
			window_pos = OS.get_window_position()
			
			OS.set_window_position(Vector2.ZERO)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			is_fullscreen = true

		else:
			OS.set_borderless_window(false)
			OS.set_window_size(window_size)
			OS.set_window_position(window_pos)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_fullscreen = false

func camera_shake(strength: float, duration: float = 1.0):
	if not camera:
		return
	camera.shake(strength, duration)

func show_side_msg(msg: String = ""):
	hud.show_text(msg)