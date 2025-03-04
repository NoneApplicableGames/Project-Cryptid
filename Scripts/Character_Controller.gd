extends CharacterBody3D

##The script to handle the character's movement. Also contains the camera controller.

#Export properties for anything we need to tune the value for.

@export_category("Physics Properties")
@export var acceleration : float
@export var max_speed : float = 10.0
@export var friction : float


@onready var camera_arm: Node3D = %CameraArm
@export_category("Camera Properties")
@export_range(0.0, 1.0, 0.01) var camera_pan_speed : float = 0.1
@export_range (-90, 90, 0.1) var camera_x_lock_max : float
@export_range (-90, 90, 0.1) var camera_x_lock_min : float

func _physics_process(delta: float) -> void:
	##Player movement physics
	var move_input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#input_vector is a vector2, we will need to conver to vector3
	
	var move_direction := Vector3 (move_input_vector.x, 0.0, move_input_vector.y)
	
	var horrizontal_velocity := move_direction * max_speed
	
	self.velocity = horrizontal_velocity
	
	const GRAVITY := Vector3.DOWN * 400.0
	self.velocity += GRAVITY * delta
	
	move_and_slide()
	
	
	##Third person camera.
	
	#We want to rotate the camera around the player to keep the roatation consistent
	var camera_input : Vector2 = Input.get_vector("camera_up", "camera_down", "camera_left", "camera_right")
	
	#convert to vector 3, as Node3D.rotate_object_local requires vector3 parameter
	
	var camera_vector := Vector3(camera_input.x, camera_input.y, 0.0)
	
	# Checking the vector != before rotating reduces errors in debugging.
	#for some reason godot takes issue with this implmenetation of camera movement
	#even though it gets an intentional result.
	
	if camera_vector != Vector3.ZERO:
		
		print(%CameraArm.rotation_degrees)
		
		#lock camera from going above a certain threshold and looping around the character
		if %CameraArm.rotation_degrees.x >= camera_x_lock_max:
			%CameraArm.rotate(camera_vector, camera_pan_speed)
		
	
	
	
	#allow player to reset camera to behind sal if its screwed up too much
	if Input.is_action_just_pressed("camera_reset"):
		#temp solution. setting x roation to player rotation should always mean the
		#camera is behind sal for now.
		
		%CameraArm.rotation= Vector3(self.rotation.x,0,0)
