extends CharacterBody2D

# General Variables
const tileSize       = 32  # Tile Size Multiplier.
var DIRECTION           # Player's Directional Input
var FACING = 1          # Player's last directional Input

func _physics_process(delta):
	# Apply Velocity to player.
	move_and_slide()


