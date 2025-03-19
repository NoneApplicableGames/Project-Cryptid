class_name PlayerCameraController
extends Node3D

##Class for the the camera that follows the player.
##
##This script controls everything to do with the with the their person camera that follows the player. This includes moving the character around the player in response to mouse and analogue stick movement.
## The camera should be able to allow the player to look directly up and down to better survey the area around them.


@export_category("Camera Movement")

##camera rotation speed has been split up for different values between mouse and analogue sticks. Mouse tends to be the more senstive input with this impementation.

@export_range(0.001, 1, 0.001) var camera_mouse_speed : float = 0.001 ##Controls how fast the camera moves in response to mouse input. Effetively mouse sensitivity.
@export_range(0.001, 1, 0.001) var camera_analogue_speed : float ##Controls how fast the camera moves in response to analogue input. Effetively analogue sensitivity.

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
	
	#Set mouse input mode to captured, hides ugly cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	




#We use _unhandled_input() over [_physics]_process() because we need to check what device the game is reciving input from.
func _unhandled_input(input_event: InputEvent) -> void:
	
	#Detect plugged in mouse, if true capture input as to rotate camera.
	if input_event is InputEventMouseMotion:
		var mouse_movement_2d : Vector2 = input_event.get_screen_relative()
		
		#x and y axises need to be swapped when converting to make camera movement 1 to 1 with mouse
		var mouse_movement_3d := Vector3(mouse_movement_2d.y, mouse_movement_2d.x, 0.0)
		
		self.rotation += mouse_movement_3d * camera_mouse_speed
		
		#clamp camera rotation to prevent jank when it loops around the player
		#Attempted to clamp at the end of unhandled_input() for ease of scope but wasnt sucessful.
		
		
		self.rotation_degrees.x = clampf(self.rotation_degrees.x, min_vertical_lock, max_vertical_lock)
	
	
	#stops unessecary input issues if joypad isnt connected.
	if input_event is InputEventJoypadMotion:
		var analogue_stick_vector = Input.get_vector("camera_left", "camera_right", "camera_down", "camera_up")
		
		#convert vector2 to vector3 to be used in calcuation
		
		var analogue_camera_direction := Vector3(analogue_stick_vector.y, analogue_stick_vector.x, 0.0)
		
		self.rotation += analogue_camera_direction * camera_analogue_speed
		
		#Seems stupid and redundant to do it this way but oh well.
		self.rotation_degrees.x = clampf(self.rotation_degrees.x, min_vertical_lock, max_vertical_lock)
	
	#Camera reset included if camera is offcentre
	
	if Input.is_action_just_pressed("camera_reset"):
		self.rotation = Vector3.ZERO
		mouse_pos_2d = Vector2.ZERO
	
	
	
