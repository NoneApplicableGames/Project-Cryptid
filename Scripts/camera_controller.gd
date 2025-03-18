class_name PlayerCameraController
extends Node3D

##Class for the the camera that follows the player.
##
##This script controls everything to do with the with the their person camera that follows the player. This includes moving the character around the player in response to mouse and analogue stick movement.
## The camera should be able to allow the player to look directly up and down to better survey the area around them.


@export_category("Camera Movement")

@export var camera_pan_speed : float = 0.1 ##Controls how fast the camera moves in response to input. Also known as how senstive it is.

@export_category("Directional Locks")

@export_range(-90, 90, 0.1) var max_vertical_lock := 90 ##The value, in degrees, of how high the camera can be moved up before stopping. Prevents the player from looping the camera around the player infinitely in a janky way. Quaterions hurt my head so we're going to avoid them if we can.
@export_range(-90, 90, 0.1) var min_vertical_lock := -90 ##Same as max_vertical_lock, but for how long the camera can go. 

var _ground_plane := Plane(Vector3.UP) ##Defines a rigid normal vector for the camera to rotate around.

var mouse_pos_2d : Vector2 ##mouse position is captured using in this scope so that it can be reset with camera_rest

@onready var _player_camera: Camera3D = %PlayerCamera ## Reference to third person camera.

#func _ready() is being used to handle all things we only want to do once, like printing control connection errors
func _ready() -> void:
	
	if get_viewport().get_mouse_position() == null:
		print("PlayerCameraController is not detecting mouse input. Did you remeber to plug a mouse in?")
	else:
		print("Mouse input detected!") 
	
	


#Physics process loop
func _physics_process(delta: float) -> void:
	
	#Detect plugged in mouse, if true capture input as Vector2. 
	#if null reduces errors if mouse not detected.
	if get_viewport().get_mouse_position() != null:
		
		mouse_pos_2d = get_viewport().get_mouse_position()
		
		var mouse_ray := _player_camera.project_local_ray_normal(mouse_pos_2d)
		
		#camera rotates to follow the mouse ray
		
		if  mouse_ray != null:
			self.look_at(mouse_ray)
	
	#stops unessecary input issues if joypad isnt connected.
	if Input.get_connected_joypads().is_empty():
		var analogue_stick_ = Input.get_vector("camera_left", "camera_right", "camera_down", "camera_up")
	
	#Camera reset included if camera is offcentre
	
	if Input.is_action_just_pressed("camera_reset"):
		self.rotation = Vector3.ZERO
		mouse_pos_2d = Vector2.ZERO

	
	#pass is placeholder
	pass
