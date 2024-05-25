extends Area2D
class_name staticNPCBase

@onready var text = $debug

func _ready():
	text.visible = false

func _process(delta):
	if text.visible and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("Hello World")
		text.visible = false




func npcApproached(body):
	text.visible = true


func npcLeft(body):
	text.visible = false
