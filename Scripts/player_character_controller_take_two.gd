extends CharacterBody3D

class_name PlayerCharacterController


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


##Export properties for anything we need to tune the value for.
##We want to avoid hardcoding as much as possible

@export_category("Ground Movement Properties")
@export var max_speed : float ## Max speed the player can achive horrizontally.
@export var acceleration : float ## The force applied to the player as they accelerate along the ground.
@export var friction : float ## The force applied to the player as they come to a stop.

@export_category("Air Movement Properties")
@export_range(1.0, 500.0, 0.1) var jump_force : float = 10.0 ## The force applied to the player when they initally jump.
@export_range(1.0, 100.0, 0.1) var down_force : float = 1.0 ## A downwards force applied to the player's jump as they are rising to create a proper parabolic arc 
@export_range(1.0, 500.0, 0.1) var gravity := 17.0 ##constant force of gravity applied to falling player
@export_range(1.0, 1000.0, 0.1) var terminal_velocity := 20.0 ##player's max falling speed
var _intial_jump_force : float ##proxy varible to store jump force as it decreases over the course of the arc. Allows it to be reset later.
var _jumping : bool = false

func _ready() -> void:
	_intial_jump_force = jump_force

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
	
	
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		
		#to create a smooth parabola we want to decrease the amount of velocity evey physics tick.
		
		var jump : Vector3= jump_force * self.up_direction * delta
		
		self.velocity.y += jump_force
		
		_jumping = true
	
	##Handles everything to do with falling
	
	if !is_on_floor():
		
		if !_jumping && self.velocity.y >= 0:
			
			self.velocity -= gravity * self.up_direction * delta
			
		
		if _jumping:
			
			jump_force -= down_force
			
			var jump : Vector3= jump_force * self.up_direction * delta
			
			self.velocity.y += jump_force
		
		#clamp speed to prevent decent from going over terminal velocity
		#we use maxf since we dont need a minium value for velocity
		
		self.velocity.y = maxf(self.velocity.y, -terminal_velocity)
	
	#reset when on floor
	if is_on_floor():
		
		_jumping = false
		jump_force = _intial_jump_force
	
	
	move_and_slide()
