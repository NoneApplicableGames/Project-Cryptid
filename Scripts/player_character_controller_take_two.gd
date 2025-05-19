extends CharacterBody3D

class_name PlayerCharacterController


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


##Export properties for anything we need to tune the value for.
##We want to avoid hardcoding as much as possible

@export_category("Ground Movement Properties")
@export var max_speed : float ## Max speed the player can achive horrizontally.
@export var ground_acceleration : float = 10.0 ## The force applied to the player as they accelerate along the ground.
@export var ground_friction : float = 10.0 ## The force applied to the player as they come to a stop.

@export_category("Air Movement Properties")
@export var air_accleration : float = 10.0
@export var air_friction : float = 10.0
@export_range(1.0, 500.0, 0.1) var jump_force : float = 10.0 ## The force applied to the player when they initally jump.
@export_range(1.0, 500.0, 0.1) var gravity := 17.0 ##constant force of gravity applied to falling player
@export_range(1.0, 1000.0, 0.1) var terminal_velocity := 20.0 ##player's max falling speed
var _jumping : bool = false
var _accel : float ##proxy varible to store vertical speed
var _gravity_vec := Vector3.ZERO
var _horrizontal_movement := Vector3.ZERO 

func _physics_process(delta: float) -> void:
	###Player movement physics
	
	##How the player moves on the ground
	var move_input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	
	#input_vector is a vector2, we will need to conver to vector3
	
	var move_direction := Vector3 (move_input_vector.x, 0.0, move_input_vector.y)
	
	
	
	##Handles everything to do with falling
	#We want the player to rise and fall in a smooth parabola
	
	if is_on_floor():
		_gravity_vec = Vector3.ZERO
		if move_direction: _accel = ground_acceleration
		else: _accel = ground_friction
	
	else:
		_gravity_vec += -up_direction * gravity * delta
		if move_direction: _accel = air_accleration
		else: _accel = air_friction
	
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		
		_gravity_vec = up_direction * jump_force
	
	#Interpolate horrizontal movement to create a smooth sense of accerating an deccelerating
	_horrizontal_movement = _horrizontal_movement.lerp(move_direction * max_speed , _accel * delta)
	self.velocity = _horrizontal_movement + _gravity_vec
	move_and_slide()
