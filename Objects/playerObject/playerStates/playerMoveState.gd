extends stateClass

# Horizontal Movement Exports
@export_group("Walk Variables")
@export var move_distance: float = 4.0
@export_subgroup("Timers")
@export var accelerate_time: float = 1
@export var deccelerate_time: float = 0.5

# Vertical Movement Exports
@export_group("Jump Variables")
@export var jump_height: float = 4.0
@export_subgroup("Jump Timers")
@export var peakTime: float = 0.5
@export var floatTime: float = 0.2
@export var fallTime: float = 0.5
@export_subgroup("Coyote Time & Jump Buffer Timer")
@export var jumpEaseTime: float = 0.1
@export var jumpBufferTime: float = 0.1



# Horizontal Movement Variables
var MAX_VELOCITY  # player's Max Speed after Acceleration.
var ACCELERATION  # player's Acceleration while pressing move-key.
var FRICTION      # player's Friction while not pressing move-key.

# Vertical Movement Variables
var JUMP_VELOCITY
var RISING_GRAVITY
var FALLING_GRAVITY
var AIR_RESISTANCE
var SLIP_VELOCITY
var SLIDE_VELOCITY

var canJump = true;
var jumpBuffer = false;
var jumpCounter: int

func enterState():
	player = stateMachine.stateMachineOwner
	MAX_VELOCITY = (2 * move_distance * player.tileSize)   # player's Max Speed after Acceleration.
	ACCELERATION = (MAX_VELOCITY)/(accelerate_time)        # player's Acceleration while pressing move-key.
	FRICTION     = (MAX_VELOCITY)/(deccelerate_time)       # player's Friction while not pressing move-key.
	AIR_RESISTANCE = (MAX_VELOCITY)/2.0
	
	JUMP_VELOCITY   = (-2.0 * jump_height * player.tileSize) / (peakTime)
	RISING_GRAVITY  = ( 2.0 * jump_height * player.tileSize) / (peakTime * peakTime)
	FALLING_GRAVITY = ( 2.0 * jump_height * player.tileSize) / (fallTime * fallTime)

func updatePhysics(delta):
	
	
	
	getGravity(delta)
	playerMovement(delta)
	playerJump(delta)
	
	
	if Input.is_action_just_pressed("player_dash") and player.is_on_floor():
		Transitioned.emit(self, "playerDodgeState")
	
	if player.is_on_wall() and player.DIRECTION:
		Transitioned.emit(self, "playerWallSlideState")

func getGravity(delta):
	var grav = RISING_GRAVITY if player.velocity.y < 0.0 else FALLING_GRAVITY
	player.velocity.y += grav * delta

func playerMovement(delta):
	if player.DIRECTION != 0:
		player.velocity.x = lerp(player.velocity.x, player.DIRECTION * MAX_VELOCITY, ACCELERATION * delta * delta)
	else:
		if player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, 0.0, FRICTION * delta * delta)
		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, AIR_RESISTANCE * delta * delta)

func playerJump(delta):
	if player.is_on_floor():
		canJump = true
		if jumpBuffer:
			player.velocity.y = JUMP_VELOCITY
			canJump = false
			jumpBuffer = false
	else:
		if canJump:
			get_tree().create_timer(jumpEaseTime).timeout.connect(jumpEaseTimeout)
	
	if Input.is_action_just_pressed("player_jump"):
		if canJump:
			player.velocity.y = JUMP_VELOCITY
			canJump = false
		else:
			jumpBuffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(jumpBufferTimeout)
	
	if Input.is_action_pressed("player_jump"):
		jumpCounter += 1
	
	if Input.is_action_just_released("player_jump"):
		jumpCounter = 0;
		if (jumpCounter <= 24) and (jumpCounter >= 12):
			player.velocity.y *= jumpCounter/24
		if jumpCounter < 12:
			player.velocity.y *= 0.5

func jumpEaseTimeout():
	canJump = false

func jumpBufferTimeout():
	jumpBuffer = false


