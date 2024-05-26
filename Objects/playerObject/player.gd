extends CharacterBody2D

# Distances
const travelDist     = 4   # Tiles that player can move during Max Jump Arc.
const jumpHeight     = 4   # Tiles that Player can ascend during Max Jump Arc.
const dashDist       = 5   # Tiles that the player can move during a Dash

# Timers
const peakTime       = .4  # Time to reach top of Jump.
const fallTime       = .35 # Time to reach floor from top of jump.
const stopTime       = .2  # Time to stop moving after letting go of direction key.
const jumpEaseTime   = 0.1 # Time after dropping off a ledge that a player can still jump.
const jumpBufferTime = 0.1 # How long after hitting the jump key that a player can still jump.
const dashTime       = 0.25 # Time to reach end of Dash
const wallJumpTime   = peakTime/2 # Time before player regains control after walljump

# General Variables
const tileSize       = 32  # Tile Size Multiplier.

# Physics Variables

#    General Variables
var DIRECTION           # Player's Directional Input
var FACING = 1          # Player's last directional Input

#    Walk/Run Variables
var MAX_VELOCITY = (2 * travelDist * tileSize)/(fallTime+peakTime) # Player's Max Speed after Acceleration.
var ACCELERATION =              (MAX_VELOCITY)/(fallTime+peakTime) # Player's Acceleration while pressing move-key.
var FRICTION     =              (MAX_VELOCITY)/(stopTime)          # Player's Friction while not pressing move-key.

var canMove = true;

#    Jump Variables
var JUMP_GRAVITY = ( 2.0 * jumpHeight * tileSize) / (peakTime * peakTime) # Player's Fall Acceleration on first half of jump.
var FALL_GRAVITY = ( 2.0 * jumpHeight * tileSize) / (fallTime * fallTime) # Player's Fall Acceleration on second half of jump.
var JUMP_SPEED   = (-2.0 * jumpHeight * tileSize) / (peakTime)            # Player's Jump Impulse.

var canJump = false;    # Player's ability to jump currently.
var jumpBuffer = false; # Player's queued jump. 
var jumpCounter = 0     # How long player has held jump

#    Dash Variables
var DASH_SPEED   = -( ( dashDist * tileSize ) - ( 0.5 * FRICTION * dashTime * dashTime ) ) / dashTime

var isDashing = false;

#    Walljump Variables









func _physics_process(delta):
	
	DIRECTION = Input.get_axis("ui_left", "ui_right")
	if DIRECTION:
		FACING = sign(DIRECTION)
	
	velocity.y += getGravity() * delta
	
	
	
	#if !isDashing:
	#	playerMovement(delta)
	
	#playerJump(delta)
	#playerDodge(delta)
	
	
	
	
	# Apply Velocity to player.
	move_and_slide()


# General Functions
func getGravity():
	# Find appropriate gravity for player.
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY

# Jump Functions
func playerJump(delta):
		# Player Jump Controller
		# Jump Checker
	if is_on_floor():
		
		# Enable player to jump.
		canJump = true
		
		# Jump if player has a jump queued
		if jumpBuffer:
			# Move Player upwards and disable their ability to jump
			velocity.y = JUMP_SPEED
			canJump = false;
			jumpBuffer = false
		
	else:
		
		# If player is off the ground, queue the jump.
		if canJump:
			get_tree().create_timer(jumpEaseTime).timeout.connect(jumpEaseTimeout)
	
	if Input.is_action_just_pressed("ui_up"):
		
		if canJump:
			
			# If jump is enabled, Jump.
			# Move Player upwards and disable their ability to jump
			velocity.y = JUMP_SPEED
			canJump = false;
			
		else:
			
			# If jump is disabled, Queue Jump.
			jumpBuffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(jumpBufferTimeout)
	
	if Input.is_action_pressed("ui_up"):
		jumpCounter += 1;
	
	if Input.is_action_just_released("ui_up"):
		
		jumpCounter = 0;
		
		if (jumpCounter <= 24) and (jumpCounter >= 12):
			velocity.y *= jumpCounter/24
		if jumpCounter < 12:
			velocity.y *= 0.5

func jumpEaseTimeout():
	# Disable player's ability to jump after jumpEaseTimer runs out.
	canJump = false

func jumpBufferTimeout():
	# Empty player's jump queue after player doesn't hit floor in time.
	jumpBuffer= false

# Move Functions
func playerMovement(delta):
	if !isDashing:
		if DIRECTION != 0:
			velocity.x = lerp(velocity.x, DIRECTION * MAX_VELOCITY, ACCELERATION * delta * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, FRICTION * delta * delta)

# Dodge Functions
func playerDodge(delta):
	if Input.is_action_just_pressed("ui_accept"):
		isDashing = true
		velocity.x = 0
		velocity.x = - DASH_SPEED * FACING
		get_tree().create_timer(dashTime).timeout.connect(dashTimeout)
		$Sprite2D.modulate = Color(1,0,1)

func dashTimeout():
	isDashing = false
	$Sprite2D.modulate = Color(1,1,1)

# WallJump Functions
func playerWallJump(delta):
	pass;
