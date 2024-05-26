extends stateClass

@export var move_distance: float = 4.0
@export var accelerate_time: float = 0.6
@export var deccelerate_time: float = 0.2


var MAX_VELOCITY  # player's Max Speed after Acceleration.
var ACCELERATION  # player's Acceleration while pressing move-key.
var FRICTION      # player's Friction while not pressing move-key.




func enterState():
	player = stateMachine.stateMachineOwner
	MAX_VELOCITY = (2 * move_distance * player.tileSize)   # player's Max Speed after Acceleration.
	ACCELERATION = (MAX_VELOCITY)/(accelerate_time)        # player's Acceleration while pressing move-key.
	FRICTION     = (MAX_VELOCITY)/(deccelerate_time)       # player's Friction while not pressing move-key.


func updatePhysics(delta):
	if player.DIRECTION != 0:
		player.velocity.x = lerp(player.velocity.x, player.DIRECTION * MAX_VELOCITY, ACCELERATION * delta * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, FRICTION * delta * delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		Transitioned.emit(self, "playerJumpState")


