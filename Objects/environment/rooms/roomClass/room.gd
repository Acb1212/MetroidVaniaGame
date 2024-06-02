
extends Node2D

@export var roomWidth: int  = 1
@export var roomHeight: int = 1
@export var tileSize: int = 32
@export var tileWidth: int = 24
@export var tileHeight: int = 16

@onready var roomArea: CollisionShape2D = $roomBounds/CollisionShape2D

var refRect: ReferenceRect
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	refRect = ReferenceRect.new()
	refRect.position = Vector2(0,0)
	refRect.size = Vector2(roomWidth * tileSize * 24, roomHeight * tileSize * 16)
	refRect.editor_only = true
	add_child(refRect)
	roomArea.shape.size = Vector2(tileSize * roomWidth * tileWidth, tileSize * roomHeight * tileHeight)
	roomArea.position = Vector2((tileSize * roomWidth * tileWidth)/2,(tileSize * roomHeight * tileHeight)/2)


func roomEntered(body):
	if body.is_in_group("playerGroup"):
		body.playerCamera.limit_left = position.x
		body.playerCamera.limit_right = (position.x) + (tileSize * roomWidth * tileWidth)
		body.playerCamera.limit_top = position.y
		body.playerCamera.limit_bottom = position.y + ( tileSize * roomHeight * tileHeight)
