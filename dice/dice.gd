class_name Dice
extends Control

const DICE_UNLOCKED_TEXTURE = preload("res://dice/assets/dice_unlocked.png")
const DICE_LOCKED_TEXTURE = preload("res://dice/assets/dice_locked.png")

const FLOATING_TEXT : PackedScene = preload("res://gui_assets/floating_text/floating_text.tscn")

@onready var dice_texture: TextureRect = $DiceTexture

@onready var lock_icon: TextureRect = %LockIcon
@onready var roll_dice_timer: Timer = $RollDiceTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var dice_array_textures : Array[Texture2D] = []
@export var alt_dice_array_textures : Array[Texture2D] = []

enum DiceStates {
	INTRO,
	IDLE,
	ROLL,
	LOCK,
	OUTRO
}

@export var dice_state : DiceStates = DiceStates.INTRO
@export var use_alt_dice : bool = false

var can_interact : bool = true

var dice_value : int = 1

signal roll_complete

func _ready() -> void:
	lock_icon.hide()
	
	if use_alt_dice:
		dice_texture.texture = alt_dice_array_textures[dice_value - 1]
	else:
		dice_texture.texture = dice_array_textures[dice_value - 1]

func _process(delta: float) -> void:
	
	match dice_state:
		
		DiceStates.INTRO:
			if !animation_player.is_playing():
				animation_player.play("DICE_INTRO")
		DiceStates.IDLE:
			if !animation_player.is_playing():
				animation_player.play("DICE_IDLE")
			
		DiceStates.ROLL:
			if !animation_player.is_playing():
				animation_player.play("DICE_ROLL")
			
			if roll_dice_timer.is_stopped():
				animation_player.stop()
				dice_state = DiceStates.IDLE
				
		DiceStates.LOCK:
			if !roll_dice_timer.is_stopped():
				can_interact = false
			else:
				can_interact = true

func start_roll_dice() -> void:
	roll_dice_timer.start(randf_range(1,2))
	
	if dice_state != DiceStates.LOCK:
		animation_player.stop()
		dice_state = DiceStates.ROLL

func _set_random_number() -> void:
	dice_value = randi_range(1,6)
	
	if use_alt_dice:
		dice_texture.texture = alt_dice_array_textures[dice_value - 1]
	else:
		dice_texture.texture = dice_array_textures[dice_value - 1]

func _on_dice_button_mouse_entered() -> void:
	if can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.show()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_UNLOCKED_TEXTURE

func _on_dice_button_mouse_exited() -> void:
	if can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.hide()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_LOCKED_TEXTURE

func _on_dice_button_button_down() -> void:
	if can_interact:
		if dice_state == DiceStates.IDLE:
			animation_player.play("DICE_LOCK")
		elif dice_state == DiceStates.LOCK:
			animation_player.play("DICE_UNLOCK")


func _on_dice_button_focus_entered() -> void:
	if can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.show()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_UNLOCKED_TEXTURE


func _on_dice_button_focus_exited() -> void:
	if can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.hide()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_LOCKED_TEXTURE


func _on_roll_dice_timer_timeout() -> void:
	roll_complete.emit()


func _on_roll_complete() -> void:
	#var floating_text : FloatingText = FLOATING_TEXT.instantiate()
	#add_child(floating_text)
	#floating_text.global_position = global_position
	#floating_text.rotation_degrees = 0
	#floating_text.start_floating_text(str(dice_value,"+"))
	pass
