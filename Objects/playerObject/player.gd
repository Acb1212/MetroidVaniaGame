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

@export var characterAbilities: Array[String] = [
	"playerDodgeState",
	"playerChainState",
	"playerSlamState"
]

func _physics_process(_delta):
	DIRECTION = Input.get_axis("ui_left", "ui_right")
	if DIRECTION:
		FACING = sign(DIRECTION)
	if Input.is_action_just_pressed("player_change_ability_L"):
		cycleAbilityLeft()
	
	if Input.is_action_just_pressed("player_change_ability_R"):
		cycleAbilityRight()
	
	$CanvasLayer/Label.text = str(characterAbilities[0])
	# Apply Velocity to player.
	move_and_slide()

func cycleAbilityLeft():
	characterAbilities.push_back(characterAbilities.pop_front())

func cycleAbilityRight():
	characterAbilities.push_front(characterAbilities.pop_back())
