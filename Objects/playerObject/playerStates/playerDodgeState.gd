extends stateClass

@export var dash_distance: float = 2
@export var dash_time: float = 0.1

var DASH_VELOCITY
var DASH_GRAVITY

func enterState():
	player = stateMachine.stateMachineOwner
	DASH_VELOCITY = dash_distance * player.tileSize/dash_time

func updatePhysics(delta):
	playerDodge(delta)

func playerDodge(delta):
	player.velocity.x = 0
	player.velocity.x = DASH_VELOCITY * player.FACING
	get_tree().create_timer(dash_time).timeout.connect(dashTimeout)

func dashTimeout():
	Transitioned.emit(self, "playerMoveState")
