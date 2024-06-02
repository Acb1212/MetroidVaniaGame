extends CharacterBody2D

# General Variables
const tileSize       = 32  # Tile Size Multiplier.
var DIRECTION           # Player's Directional Input
var FACING = 1          # Player's last directional Input

@onready var playerSprite = $Sprite2D
@onready var playerCollider = $CollisionShape2D
@onready var anim = $AnimationPlayer
@onready var playerCamera = $Camera2D
var currentJumps = 1


func _physics_process(_delta):
	DIRECTION = Input.get_axis("ui_left", "ui_right")
	if DIRECTION:
		FACING = sign(DIRECTION)
	# Apply Velocity to player.
	move_and_slide()


