class_name Dice
extends Control

@export var dice_sprites : Array[Texture2D]
@onready var dice_texture: TextureRect = $DiceTexture
@onready var roll_timer: Timer = $RollTimer
@onready var change_sprite_timer: Timer = $ChangeSpriteTimer

var current_number : int = 1
var is_rolling : bool = false
var is_locked : bool = false

func _ready() -> void:
	reset_dice()

func roll_dice() -> void:
	if !is_locked:
		is_rolling = true
		change_sprite_timer.start()
		roll_timer.start(randf_range(1,2))

func reset_dice() -> void:
	dice_texture.texture = dice_sprites[0]

func _on_change_sprite_timer_timeout() -> void:
	if !roll_timer.is_stopped():
		current_number = randi_range(1,6)
		dice_texture.texture = dice_sprites[1 - current_number]
	else:
		is_rolling = false
		change_sprite_timer.stop()

@onready var lock_icon: TextureRect = $LockIcon
@onready var locked_color: ColorRect = %LockedColor

func _on_lock_button_pressed() -> void:
	if !is_rolling:
		is_locked = !is_locked
		
		if is_locked:
			lock_icon.show()
			locked_color.show()
		else:
			lock_icon.hide()
			locked_color.hide()
