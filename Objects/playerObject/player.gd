extends CharacterBody2D

const travelDist     = 4   # Tiles that player can move during Max Jump Arc.
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

var floorFrictionFactor = 1.0;

var canJump = false;    # Player's ability to jump currently.
var jumpBuffer = false; # Player's queued jump. 
var jumpCounter = 0     # How long player has held jump


func _physics_process(delta):
	# Apply correct Gravity to player.
	velocity.y += getGravity() * delta
	
	
	# Get Directional Input
	var DIRECTION = Input.get_axis("ui_left", "ui_right")
	
	playerJump(delta)
	
	
	
	if DIRECTION != 0:
		
		# If Move-Keys are pressed, accelerate towards MAX_VELOCITY * DIRECTION
		velocity.x = lerp(velocity.x, DIRECTION * MAX_VELOCITY,ACCELERATION * delta * delta) 
		
	else:
		
		# If Move-Keys are not pressed, deccelerate towards 0 velocity.
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta * delta) 
	
	# Show if player is on ground for debug
	$Label.text = "Is on Ground : " + str(is_on_floor())
	
	# Apply Velocity to player.
	move_and_slide()



func jumpEaseTimeout():
	
	# Disable player's ability to jump after jumpEaseTimer runs out.
	canJump = false

func jumpBufferTimeout():
	
	# Empty player's jump queue after player doesn't hit floor in time.
	jumpBuffer= false

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

	

func getGravity():
	
	# Find appropriate gravity for player.
	return JUMP_GRAVITY if velocity.y < 0.0 else FALL_GRAVITY