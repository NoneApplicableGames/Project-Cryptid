extends CharacterBody3D
class_name PlayerCharacterController


##The script to handle the character's movement.
##It governs everything in relation on player physics and input handling.


#Export properties for anything we need to tune the value for.

@export_category("Physics Properties")
@export var acceleration : float
@export var max_speed : float = 10.0
@export var friction : float


@onready var camera_arm: Node3D = %CameraArm

func _physics_process(delta: float) -> void:
	##Player movement physics
	var move_input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#input_vector is a vector2, we will need to conver to vector3
	
	var move_direction := Vector3 (move_input_vector.x, 0.0, move_input_vector.y)
	
	var horrizontal_velocity := move_direction * max_speed
	
	self.velocity = horrizontal_velocity
	
	const GRAVITY := Vector3.DOWN * 600.0
	
	if !is_on_floor():
		self.velocity += GRAVITY * delta
	
	move_and_slide()
	
