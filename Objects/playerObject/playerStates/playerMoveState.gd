extends stateClass

# Horizontal Movement Exports
@export_group("Walk Variables")
@export var move_distance: float = 3.0
@export var move_time: float = 1.0
@export var accelerate_time: float = 0.5
@export var friction_time: float = 0.5
@export var air_friction_time: float = 0.5


# Vertical Movement Exports
@export_group("Jump Variables")
@export var jump_count: float = 2
@export var jump_height: float = 2
@export var wall_jump_distance: float = 4.0
@export var wall_jump_height: float = 2.0

@export var peakTime: float = 0.35
@export var fallTime: float = 0.3

@export var jumpEaseTime: float = 0.1
@export var jumpBufferTime: float = 0.1

# Horizontal Movement Variables
var MAX_VELOCITY  
var MOVE_ACCELERATION  
var MOVE_FRICTION     

# Vertical Movement Variables
var JUMP_VELOCITY
var JUMP_GRAVITY1
var JUMP_GRAVITY2
var JUMP_FRICTION

var WALLJUMP_VELOCITY_X
var WALLJUMP_VELOCITY_Y

var canJump = false;
var canWallJump = false
var jumpBuffer = false;
var wallJumpBuffer = false;
var jumpCounter: int

var isSliding = false


func enterState():
	player = stateMachine.stateMachineOwner
	MAX_VELOCITY      = ( 2.0 * move_distance * player.tileSize)/move_time 
	MOVE_ACCELERATION = (MAX_VELOCITY)/(accelerate_time)       
	MOVE_FRICTION     = (MAX_VELOCITY)/(friction_time)       
	
	JUMP_VELOCITY     = ( -2.0 * jump_height * player.tileSize) / (peakTime)
	JUMP_GRAVITY1     = ( 2 * jump_height * player.tileSize) / (peakTime * peakTime)
	JUMP_GRAVITY2     = ( 2 *  jump_height * player.tileSize) / (fallTime * fallTime)
	JUMP_FRICTION     = (  MAX_VELOCITY ) / air_friction_time
	
	WALLJUMP_VELOCITY_X = ( 2.0 * wall_jump_distance * player.tileSize ) / move_time
	WALLJUMP_VELOCITY_Y = ( 2.0 * wall_jump_height   * player.tileSize ) / peakTime




func updatePhysics(delta):
	getGravity(delta)
	playerMovement(delta)
	playerJump(delta)
	
	player.playerLabel.text = str(player.currentJumps)
	
	if Input.is_action_just_pressed("player_dash"):
		Transitioned.emit(self, "playerDodgeState")

func getGravity(delta):
	var grav = JUMP_GRAVITY1 if player.velocity.y < 0.0 else JUMP_GRAVITY2
	player.velocity.y += grav * delta

func playerMovement(delta):
	if player.DIRECTION != 0:
		player.playerLabel.text = str(canJump)
		player.velocity.x = lerp(player.velocity.x, player.DIRECTION * MAX_VELOCITY, MOVE_ACCELERATION * delta * delta)
	else:
		if player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, 0.0, MOVE_FRICTION * delta * delta)
		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, JUMP_FRICTION * delta * delta)

func playerJump(delta):
	if player.is_on_floor():
		player.currentJumps = jump_count
	
	if player.is_on_floor() or (player.currentJumps != 0  and !canWallJump):
		canJump = true
		wallJumpBuffer = false
		if jumpBuffer:
			player.velocity.y = JUMP_VELOCITY
			canJump = false
			jumpBuffer = false
	else:
		get_tree().create_timer(jumpEaseTime).timeout.connect(jumpEaseTimeout)
	
	
	
	
	
	if player.is_on_wall_only():
		canWallJump = true
		if wallJumpBuffer:
			player.velocity.y = JUMP_VELOCITY
			player.velocity.x = MAX_VELOCITY * player.get_wall_normal().x
			canWallJump = false
			wallJumpBuffer = false
	else: 
		canWallJump = false
	
	
	if Input.is_action_just_pressed("player_jump"):
		if canJump:
			player.currentJumps -=1
			player.velocity.y = JUMP_VELOCITY
			canJump = false
		else:
			jumpBuffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(jumpBufferTimeout)
		
		if canWallJump:
			player.velocity.y = JUMP_VELOCITY
			player.velocity.x = MAX_VELOCITY * player.get_wall_normal().x
			canWallJump = false
		else:
			if !player.is_on_floor():
				wallJumpBuffer = true
				get_tree().create_timer(jumpBufferTime).timeout.connect(wallJumpBufferTimeout)
	
	
	
	
	
	# Variable Jump
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

func wallJumpEaseTimeout():
	canWallJump = false

func jumpBufferTimeout():
	jumpBuffer = false

func wallJumpBufferTimeout():
	wallJumpBuffer =  false


