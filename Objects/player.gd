extends CharacterBody2D

const travelDist     = 3   # Tiles that player can move during Max Jump Arc.
const jumpHeight     = 4   # Tiles that Player can ascend during Max Jump Arc.

# Timers
const peakTime       = .4  # Time to reach top of Jump.
const fallTime       = .35 # Time to reach floor from top of jump.
const stopTime       = .2  # Time to stop moving after letting go of direction key.
const jumpEaseTime   = 0.1 # Time after dropping off a ledge that a player can still jump.
const jumpBufferTime = 0.1 # How long after hitting the jump key that a player can still jump.

const tileSize       = 32  # Tile Size Multiplier.


var MAX_VELOCITY = (2 * travelDist * tileSize)/(fallTime+peakTime) # Player's Max Speed after Acceleration.
var ACCELERATION =              (MAX_VELOCITY)/(fallTime+peakTime) # Player's Acceleration while pressing move-key.
var FRICTION     =              (MAX_VELOCITY)/(stopTime)          # Player's Friction while not pressing move-key.

var JUMP_GRAVITY = ( 2.0 * jumpHeight * tileSize) / (peakTime * peakTime) # Player's Fall Acceleration on first half of jump.
var FALL_GRAVITY = ( 2.0 * jumpHeight * tileSize) / (fallTime * fallTime) # Player's Fall Acceleration on second half of jump.
var JUMP_SPEED   = (-2.0 * jumpHeight * tileSize) / (peakTime)            # Player's Jump Impulse.

var canJump = false;    # Player's ability to jump currently.
var jumpBuffer = false; # Player's queued jump. 



func _physics_process(delta):
	# Apply correct Gravity to player.
	velocity.y += getGravity() * delta
	
	# Jump Checker
	if is_on_floor():
		
		# Enable player to jump.
		canJump = true
		
		# Jump if player has a jump queued
		if jumpBuffer:
			playerJump(1)
			jumpBuffer = false
		
		
	else:
		
		# If player is off the ground, queue the jump.
		if canJump:
			get_tree().create_timer(jumpEaseTime).timeout.connect(jumpEaseTimeout)
	
	# Get Directional Input
	var DIRECTION = Input.get_axis("ui_left", "ui_right")
	
	
	# Player Jump Controller
	if Input.is_action_just_pressed("ui_up"):
		
		
		if canJump:
			
			# If jump is enabled, Jump.
			playerJump(1)
			
		else:
			
			# If jump is disabled, Queue Jump.
			jumpBuffer = true
			get_tree().create_timer(jumpBufferTime).timeout.connect(jumpBufferTimeout)
	
	# Player Short Jump Controller
	if Input.is_action_just_released("ui_up"):
		
		# If player released Jump-Key before jump has peaked, cut it short.
		if velocity.y < 0:
			playerJump(.5)
	
	if DIRECTION != 0:
		
		# If Move-Keys are pressed, accelerate towards MAX_VELOCITY * DIRECTION
		velocity.x = lerp(velocity.x, DIRECTION * MAX_VELOCITY,ACCELERATION * delta * delta) 
		
	else:
		
		# If Move-Keys are not pressed, deccelerate towards 0 velocity.
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta * delta) 
	
	# Apply Velocity to player.
	move_and_slide()



func jumpEaseTimeout():
	
	# Disable player's ability to jump after jumpEaseTimer runs out.
	canJump = false

func jumpBufferTimeout():
	
	# Empty player's jump queue after player doesn't hit floor in time.
	jumpBuffer= false

func playerJump(jumpFactor):
	
	# Move Player upwards and disable their ability to jump
	velocity.y = jumpFactor * JUMP_SPEED
	canJump = false;

func getGravity():
	
	# Find appropriate gravity for player.
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY
