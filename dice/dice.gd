class_name Dice
extends Control

@onready var dice_texture: TextureRect = $DiceTexture


func _ready() -> void:
	var animated_texture : AnimatedTexture = dice_texture.texture
	
	animated_texture.current_frame = randi_range(1,6)
