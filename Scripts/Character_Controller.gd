extends CharacterBody3D

@export_category("Gravity Properties")
@export var weight : float

@export_category("Speed Properties")
@export var acceleration : float
@export var max_speed : float = 10
@export var friction : float

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#convert to vector 3 for velocity
	
	var direction := Vector3 (input_vector.x, 0.0, input_vector.y)
	
	print("Direction = ", direction)
	
	self.velocity = direction * max_speed
