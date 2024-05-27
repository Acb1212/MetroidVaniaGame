extends stateClass

@export_group("Wall Slide Variables")
@export var slipDist: float = 8.0
@export var slideDist: float = 30.0
@export var slipTime: float = 2

@export_group("Wall Jump Variables")
@export var jumpHeight: float = 0.75
@export var jumpDist: float = 1
@export var controlTime: float = .1

var SLIP_VELOCITY
var SLIDE_VELOCITY
var JUMP_VELOCITY
var MOVE_VELOCITY

func enterState():
	player = stateMachine.stateMachineOwner
	SLIP_VELOCITY = (slipDist * player.tileSize)/slipTime
	SLIDE_VELOCITY = (slideDist * player.tileSize)/slipTime
	JUMP_VELOCITY = (-jumpDist * player.tileSize)/controlTime
	MOVE_VELOCITY = (jumpDist * player.tileSize)/controlTime

func updatePhysics(delta):
	playerWallSlide(delta)
	playerWallJump(delta)
	
	if player.is_on_floor():
		Transitioned.emit(self, "playerMoveState")

func playerWallSlide(delta):
	print(str(player.get_wall_normal().x) + " : " + str(player.DIRECTION) )
	if player.is_on_wall():
		player.velocity.y = SLIP_VELOCITY
		if Input.is_action_pressed("player_down"):
			player.velocity.y = SLIDE_VELOCITY
	if player.get_wall_normal().x == player.DIRECTION and player.is_on_wall():
		Transitioned.emit(self, "playerMoveState")

func playerWallJump(delta):
	if Input.is_action_just_pressed("player_jump"):
		player.velocity.x = MOVE_VELOCITY * player.get_wall_normal().x
		player.velocity.y = JUMP_VELOCITY
		player.DIRECTION *= -1
		get_tree().create_timer(controlTime).timeout.connect(jumpTimeout)

func jumpTimeout():
	Transitioned.emit(self, "playerMoveState")
