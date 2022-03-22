class_name VS
extends Node2D

var sprites = []

var friend_count = 0
var friends_num = 0

func _ready():
	pass

# ------------------
# initialize with the sprite
# ------------------
func initialize(sprite):
	# warning-ignore: unused_variable
	sprites = get_children()
	friends_num = sprites.size()
	for s in sprites:
		s.texture = sprite.texture
		s.hframes = sprite.hframes
		s.vframes = sprite.vframes

# the frame index and sprite scale
func bang(f, s, pos:Vector2):
	sprites[friend_count].bang(f, s)
	sprites[friend_count].global_position = pos
	friend_count += 1
	if friend_count >= friends_num:
		friend_count -= friends_num


