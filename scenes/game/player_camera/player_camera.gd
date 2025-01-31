class_name PlayerCamera
extends CharacterBody3D

@onready var forward_solid_detector: RayCast3D = $ForwardSolidDetector
@onready var back_solid_detector: RayCast3D = $BackSolidDetector


enum MovementStates {
	IDLE,
	WALK,
	ROTATE
}

var movement_state : MovementStates = MovementStates.IDLE

var target_pos : Vector3 = Vector3.ZERO
var target_angle : float = 0.0

func _process(delta: float) -> void:
	
	match movement_state:
		MovementStates.IDLE:
			
			target_angle = 0
			
			if Input.is_action_pressed("walk_forward") :
				if !forward_solid_detector.is_colliding():
					target_pos = global_position - (transform.basis * Vector3(0,0,2))
					movement_state = MovementStates.WALK
			elif Input.is_action_pressed("walk_backwards") :
				if !back_solid_detector.is_colliding():
					target_pos = global_position - (transform.basis * Vector3(0,0,-2))
					movement_state = MovementStates.WALK
				
			if Input.is_action_pressed("turn_left"):
				target_angle = global_rotation.y + deg_to_rad(90)
				movement_state = MovementStates.ROTATE
			elif Input.is_action_pressed("turn_right"):
				target_angle = global_rotation.y - deg_to_rad(90)
				movement_state = MovementStates.ROTATE
			
		MovementStates.WALK:
			global_position = lerp(global_position,target_pos,delta * 20)
			
			if global_position.is_equal_approx(target_pos):
				global_position = target_pos
				movement_state = MovementStates.IDLE
			
		MovementStates.ROTATE:
			
			if is_equal_approx(270, rad_to_deg(target_angle)): target_angle = deg_to_rad(-90)
			elif is_equal_approx(-270, rad_to_deg(target_angle)): target_angle = deg_to_rad(90)
			
			global_rotation.y = lerp_angle(global_rotation.y, target_angle, delta * 20)
			
			if is_equal_approx(global_rotation.y, target_angle):
				global_rotation.y = target_angle
				target_angle = 0
				movement_state = MovementStates.IDLE
				
	
	
