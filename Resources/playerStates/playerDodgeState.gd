extends stateClass

@export var dash_distance: float = 2
@export var dash_time: float = 0.1
@onready var afterImage = preload("res://Objects/environment/effects/after_image.tscn")

var DASH_VELOCITY
var DASH_GRAVITY

func enterState():
	player = stateMachine.stateMachineOwner
	
	DASH_VELOCITY = dash_distance * player.tileSize/dash_time
	
	

func updatePhysics(delta):
	playerDodge(delta)

func playerDodge(_delta):
	var mirage = afterImage.instantiate()
	mirage.texture = player.playerSprite.texture
	mirage.scale = player.playerSprite.scale
	mirage.lifetime = 1
	get_parent().get_parent().get_parent().add_child(mirage)
	mirage.global_position = global_position
	
	
	player.velocity.x = 0
	player.velocity.x = DASH_VELOCITY * player.FACING
	get_tree().create_timer(dash_time).timeout.connect(dashTimeout)
	player.anim.play("playerSquish")

func dashTimeout():
	Transitioned.emit(self, "playerMoveState")

func exitState():
	player.velocity.x *= 0.5
