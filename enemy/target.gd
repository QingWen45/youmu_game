extends Area2D

onready var dialog = $dialog_box
onready var lb = $Label

var health = 100

func _ready():
	pass

func _process(_delta):
	lb.text = str(health)

func hurt(area, damage):
	health -= damage
	print(area.name)
