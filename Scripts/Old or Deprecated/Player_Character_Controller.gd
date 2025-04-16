extends CharacterBody3D


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


##Export properties for anything we need to tune the value for.

@export_category("Ground Movement Properties")
@export var max_speed : float = 10.0 ## Max speed the player can achive horrizontally.
@export var acceleration : float ## The force applied to the player as they accelerate along the ground.
@export var friction : float ## The force applied to the player as they come to a stop.


@export_category("Air Movement Properties")
@export_range(1.0, 100.0, 0.1) var jump_velocity : float = 10.0 ##The force applied to the player when they initally jump.
@export_range(0, 1, 0.1) var jump_arc_percentage : float = 0.5 ##The percentage of the jump force that will be applied when the player starts jumping to create a smooth arc
@export var gravity := 17.0 ##constant force of gravity applied to falling player
@export var terminal_velocity := 20.0 ##player's max falling speed

var _jumping : bool = false

func _physics_process(delta: float) -> void:
	###Player movement physics
	
	
	##How the player moves on the ground
	var move_input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
	#input_vector is a vector2, we will need to conver to vector3
	
	var move_direction := Vector3 (move_input_vector.x, 0.0, move_input_vector.y)
	
	#check if input vector is ZERO to reduce unesscary errors
	if move_direction != Vector3.ZERO:
		var horrizontal_velocity := move_direction * max_speed
		self.velocity = horrizontal_velocity
	
	else: 
		self.velocity = Vector3.ZERO
	
	##How the player moves in the air
	
	#the down_force is a force caculated every cycle to put the player down to simulate gravity
	#we put it here so we can use it in other statements to apply gravity only as needed.
	var down_force := (gravity * delta) * Vector3.DOWN
	
	if Input.is_action_pressed("jump"):
		# the upwards force is the force that is applied to the player while jumping
		var upwards_force := (jump_velocity * delta) * Vector3.UP
		if is_on_floor() && _jumping == false:
			
			# start by adding a fraction of the jump force to the current velocity
			# we're aiming for a smooth arc
			self.velocity += upwards_force
	
	# gravity should only be applied if the player is falling. the player shouldnt have to fight
	# gravity when jumping
	if !is_on_floor():
		#check if the player is currently jumping before applying gravity
		self.velocity += down_force
		# clamp fall speed so it doesnt go over terminal velocity
		# we use maxf since velocity.y never needs a minimum value
		self.velocity.y = maxf(velocity.y, -terminal_velocity)
	
	print ("Vertical Speed: " , velocity.y, "m/s")
	move_and_slide()
	
