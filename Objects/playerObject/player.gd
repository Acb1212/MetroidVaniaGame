extends CharacterBody2D

# General Variables
const tileSize       = 32  # Tile Size Multiplier.
var DIRECTION           # Player's Directional Input
var FACING = 1          # Player's last directional Input

@onready var playerSprite = $Sprite2D
@onready var playerLabel = $Label
var currentJumps = 1


func _physics_process(delta):
	DIRECTION = Input.get_axis("ui_left", "ui_right")
	if DIRECTION:
		FACING = sign(DIRECTION)
	# Apply Velocity to player.
	move_and_slide()


