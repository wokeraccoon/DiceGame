class_name PlayerCamera
extends CharacterBody3D

var input_target_rotation : float = 0
var input_target_position : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	if global_position == input_target_position and snappedf(rad_to_deg(global_rotation.y) - snappedf(rad_to_deg(global_rotation.y),0.1),0.01) == 0:
		if Input.is_action_pressed("walk_forward"):
			input_target_position = global_position - (transform.basis * Vector3(0,0,2))
			
		if Input.is_action_pressed("walk_backwards"):
			input_target_position = global_position + (transform.basis * Vector3(0,0,2))
		
		if Input.is_action_just_pressed("turn_left"):
			input_target_rotation += deg_to_rad(90)
			
		if Input.is_action_just_pressed("turn_right"):
			input_target_rotation -= deg_to_rad(90)
				
	
	global_rotation.y = lerp_angle(global_rotation.y, input_target_rotation, delta * 20)
	print()
	
	global_position = lerp(global_position,input_target_position,delta * 10)
	
	if input_target_position.distance_to(global_position) <= 0.1:
		global_position = input_target_position
	
