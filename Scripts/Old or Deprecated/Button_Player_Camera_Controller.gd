extends Node3D

##Old script for handling camera movement using the arrow keys. 

#reference to the camera
@onready var camera: Camera3D = %PlayerCamera

##Export varibles that allow us to fine tune camera behaviour.
@export_category("Third Person Camera Settings")
##How fast the camera moves around the player.
@export_range(0.0, 1.0, 0.01) var camera_pan_speed : float = 0.1
##The point on the x axsis in degrees the camera will stop moving up. Prevents camera from looping around the player.
@export_range (-90, 90, 0.1) var camera_x_lock_max : float
##The point on the x axsis in degrees the camera will stop moving down. Prevents camera from looping around the player as well as 
@export_range (-90, 90, 0.1) var camera_x_lock_min : float


#camera will update every physics tick to keep it stable and smooth.
#(Maybe this will backfire, we'll find out)

func _physics_process(delta) -> void:
	
	#We want to rotate the camera around the player to keep the roatation consistent
	
	#Get mouse input.
	var camera_direction_2d = Input.get_vector("camera_down", "camera_up", "camera_left", "camera_right")
	
	
	#mouse input is vector 2, need to convert to vector 3 for panning the camera
	var camera_direction := Vector3(-camera_direction_2d.x, camera_direction_2d.y, 0.0).normalized()
	
	
	#check if camera_direction is not null to prevent errors
	if camera_direction != Vector3.ZERO:
		self.rotate(camera_direction, camera_pan_speed)
	
	
	#reset the camera's position to behind the player
	if Input.is_action_just_pressed("camera_reset"):
		self.rotation = Vector3(0,0,0)
	
	
	
	#pass placeholder to prevent errors if something gets commented out or removed.
	pass



















	
	#convert to vector 3, as Node3D.rotate_object_local requires vector3 parameter
	
	#var camera_vector := Vector3(camera_input.x, camera_input.y, 0.0)
	
	# Checking the vector != before rotating reduces errors in debugging.
	#for some reason godot takes issue with this implmenetation of camera movement
	#even though it gets an intentional result.
	
	#if camera_vector != Vector3.ZERO:
		
		#print(self.rotation_degrees)
		
		#lock camera from going above a certain threshold and looping around the character
		#if %CameraArm.rotation_degrees.x >= camera_x_lock_max:
			#%CameraArm.rotate(camera_vector, camera_pan_speed)
		
	
	
	#allow player to reset camera to behind sal if its screwed up too much
	#if Input.is_action_just_pressed("camera_reset"):
		#temp solution. setting x roation to player rotation should always mean the
		#camera is behind sal for now.
		
		#self.rotation= Vector3(self.rotation.x,0,0)
	
