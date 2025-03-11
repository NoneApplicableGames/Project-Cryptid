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

var ground_plane := Plane(Vector3.UP) ##Defines a rigid normal vector for the camera to rotate around.

@onready var player_camera: Camera3D = %PlayerCamera ## Reference to third person camera.

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
		var mouse_pos_2d : Vector2 = get_viewport().get_mouse_position()
	
	
	
	#pass is placeholder
	pass
