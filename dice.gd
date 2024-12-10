class_name Dice
extends Node2D

var dice_value : int = 1
var is_locked : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var roll_timer: Timer = $RollTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var mouse_detector: Area2D = $MouseDetector
@onready var locked_label: Label = $LockedLabel
@onready var ammount_label: Label = $AmmountLabel

signal dice_rolled(value : int)

func roll() -> void:
	if !is_locked:
		animation_player.play("rolling")
	roll_timer.start(randf_range(1,1.5))

func choose_random_side() -> void:
	var sides : int = sprite.sprite_frames.get_frame_count("default")
	
	sprite.frame = randf_range(0, sides)
	
	dice_value = sprite.frame + 1 
	ammount_label.text = str(dice_value)


func _on_roll_timer_timeout() -> void:
	animation_player.stop()
	dice_rolled.emit(dice_value)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if !animation_player.is_playing():
		if event is InputEventMouseButton:
			var mouse_event : InputEventMouseButton = event
			
			if mouse_event.pressed:
				is_locked = !is_locked
				
				if is_locked:
					locked_label.text = "Locked!"
				else:
					locked_label.text = "Unlocked!"
				


func _on_mouse_detector_mouse_entered() -> void:
	if !is_locked:
		locked_label.text = "Lock?"
	else:
		locked_label.text = "Unlock?"


func _on_mouse_detector_mouse_exited() -> void:
	if !is_locked:
		locked_label.text = ""
	else:
		locked_label.text = "Locked!"
