extends stateClass

@export var jump_height: float = 1.0
@export var jump_distance: float = 8.0
@export var peakTime: float = 0.4
@export var fallTime: float = 0.35
@export var controlTime: float = .2

@export var slip_height: float = 4.0
@export var slide_height: float = 4.0
@export var slipTime: float = 2

var V_JUMP_SPEED
var H_JUMP_SPEED
var RISING_GRAVITY
var FALLING_GRAVITY

var SLIP_SPEED
var SLIDE_SPEED

func enterState():
	player = stateMachine.stateMachineOwner
	player.FACING *= -1
	player.velocity.y = 0
	V_JUMP_SPEED = (-2 * jump_height * player.tileSize)/(peakTime)
	H_JUMP_SPEED = (2 * jump_distance * player.tileSize)/(peakTime + fallTime)
	
	RISING_GRAVITY = ( 2.0 * jump_height * player.tileSize) / (peakTime * peakTime)
	FALLING_GRAVITY = ( 2.0 * jump_height * player.tileSize) / (fallTime * fallTime)
	
	SLIP_SPEED = ( 2.0 * slip_height * player.tileSize)  / (slipTime )
	SLIDE_SPEED = ( 2.0 * slide_height * player.tileSize) / (slipTime/10 )

func updatePhysics(delta):
	if Input.is_action_just_pressed("ui_accept"):
		playerJump(delta)
	
	if Input.is_action_pressed("ui_down"):
		playerSlide(delta)
	else:
		playerSlip(delta)
	
	if player.is_on_floor():
		Transitioned.emit(self, "playerMoveState")

func playerSlip(delta):
	player.velocity.y += SLIP_SPEED * delta

func playerJump(delta):
	player.velocity.y = V_JUMP_SPEED
	player.velocity.x = H_JUMP_SPEED * player.FACING
	get_tree().create_timer(controlTime).timeout.connect(controlTimeout)

func playerSlide(delta):
	player.velocity.y += SLIDE_SPEED * delta

func controlTimeout():
	Transitioned.emit(self, "playerMoveState")
