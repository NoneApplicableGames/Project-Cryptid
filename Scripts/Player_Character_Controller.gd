extends CharacterBody3D
class_name PlayerCharacterController


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


##Export properties for anything we need to tune the value for.

@export_category("Ground Movement Properties")
@export var max_speed : float = 10.0 ## Max speed the player can achive horrizontally.
@export var acceleration : float ## The force applied to the player as they accelerate along the ground.
@export var friction : float ## The force applied to the player as they come to a stop.


@export_category("Move Movement Properties")
@export var jump_velocity : float = 10.0 ##The force applied to the player when they initally jump.
@export var mass := 17.0 ##constant force of gravity applied to falling player
@export var terminal_velocity := 20.0 ##player's max falling speed
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	##Player movement physics
	var move_input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
	#input_vector is a vector2, we will need to conver to vector3
	
	var move_direction := Vector3 (move_input_vector.x, 0.0, move_input_vector.y)
	
	#check if input vector is ZERO to reduce unesscary errors
	if move_direction != Vector3.ZERO:
		var horrizontal_velocity := move_direction * max_speed
		self.velocity = horrizontal_velocity
	
	else: 
		self.velocity = Vector3.ZERO
	
	
	
	if Input.is_action_pressed("jump"):
		var upwards_force := (jump_velocity * delta) * Vector3.UP
		if is_on_floor():
			# start by adding a fraction of the jump force into the 
			self.velocity.y
	
	# gravity should only be applied if the player is falling. the player shouldnt have to fight
	# gravity when jumping
	if !is_on_floor():
		#check if the jump button is being held before 
		var down_force := (mass * gravity * delta) * Vector3.DOWN
		self.velocity += down_force
		# clamp fall speed so it doesnt go over terminal velocity
		# we use maxf since velocity.y never needs a minimum value
		self.velocity.y = maxf(velocity.y, -terminal_velocity)
	
	print ("Vertical Speed: " , velocity.y, "m/s")
	move_and_slide()
	
