class_name Dice
extends Control

@export var dice_sprites : Array[Texture2D]
@onready var dice_texture: TextureRect = $DiceTexture
@onready var roll_timer: Timer = $RollTimer
@onready var change_sprite_timer: Timer = $ChangeSpriteTimer
@onready var lock_button: Button = $LockButton

var current_number : int = 1
var is_rolling : bool = false
var is_locked : bool = false

var is_dice_disabled : bool = false

signal roll_finished()

func _ready() -> void:
	reset_dice()

func disable_dice() -> void:
	is_dice_disabled = true
	lock_button.disabled = true

func roll_dice() -> void:
	is_rolling = true
	change_sprite_timer.start()
	roll_timer.start(randf_range(1,2))

func reset_dice() -> void:
	dice_texture.texture = dice_sprites[0]
	is_locked = false
	lock_icon.hide()
	locked_color.hide()

func _on_change_sprite_timer_timeout() -> void:
	if !roll_timer.is_stopped():
		if !is_locked:
			current_number = randi_range(1,6)
			dice_texture.texture = dice_sprites[current_number - 1]
	else:
		is_rolling = false
		change_sprite_timer.stop()
		roll_finished.emit()

@onready var lock_icon: TextureRect = %LockIcon
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
