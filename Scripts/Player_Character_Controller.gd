extends CharacterBody3D
class_name PlayerCharacterController


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


##Export properties for anything we need to tune the value for.

@export_category("Movement Properties")
@export var max_speed : float = 10.0 ## Max speed the player can achive horrizontally.
@export var acceleration : float ## The force applied to the player as they accelerate along the ground.
@export var friction : float ## The force applied to the player as they come to a stop.

@export_category("Jump Properties")
@export var jump_force : float = 100.0 ##The force applied to the player when they initally jump.

@export_category("Falling Properties")
@export var mass : float = 1.0 ## The mass of the player character.
const GRAVIY := 1.0 * Vector3.DOWN ##The force of gravity


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
	
	
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		self.velocity.y += jump_force
	
	if !is_on_floor():
		self.velocity += GRAVIY * mass
	
	move_and_slide()
	
