class_name Dice
extends Control

const DICE_UNLOCKED_TEXTURE = preload("res://dice/assets/dice_unlocked.png")
const DICE_LOCKED_TEXTURE = preload("res://dice/assets/dice_locked.png")

const FLOATING_TEXT : PackedScene = preload("res://gui_assets/floating_text/floating_text.tscn")

@onready var dice_texture: TextureRect = $DiceTexture

@onready var lock_icon: TextureRect = %LockIcon
@onready var roll_dice_timer: Timer = $RollDiceTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dice_button: Button = %DiceButton

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

@export var player_can_interact : bool = true

var dice_value : int = 1

signal roll_complete

func _ready() -> void:
	lock_icon.hide()
	
	if use_alt_dice:
		dice_texture.texture = alt_dice_array_textures[dice_value - 1]
	else:
		dice_texture.texture = dice_array_textures[dice_value - 1]
	
	dice_state = DiceStates.INTRO
	
	if !player_can_interact:
		dice_button.focus_mode = Control.FOCUS_NONE
		dice_button.disabled = true
	else:
		dice_button.disabled = false
	
	animation_player.play("DICE_INTRO")

func _process(delta: float) -> void:
	
	match dice_state:
		
		DiceStates.IDLE:
			if !animation_player.is_playing():
				animation_player.play("DICE_IDLE")
			
		DiceStates.ROLL:
			if !animation_player.is_playing():
				animation_player.play("DICE_ROLL")
				
	if !roll_dice_timer.is_stopped() and player_can_interact:
		dice_button.disabled = true
	else:
		dice_button.disabled = false

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
	if !dice_button.disabled and player_can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.show()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_UNLOCKED_TEXTURE

func _on_dice_button_mouse_exited() -> void:
	if !dice_button.disabled and player_can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.hide()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_LOCKED_TEXTURE

func _on_dice_button_button_down() -> void:
	if !dice_button.disabled and player_can_interact:
		if dice_state == DiceStates.IDLE:
			animation_player.play("DICE_LOCK")
		elif dice_state == DiceStates.LOCK:
			animation_player.play("DICE_UNLOCK")

func reset_dice() -> void:
	_ready() 

func _on_dice_button_focus_entered() -> void:
	if !dice_button.disabled and player_can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.show()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_UNLOCKED_TEXTURE


func _on_dice_button_focus_exited() -> void:
	if !dice_button.disabled and player_can_interact:
		if dice_state == DiceStates.IDLE:
			lock_icon.hide()
		elif dice_state == DiceStates.LOCK:
			lock_icon.texture = DICE_LOCKED_TEXTURE


func _on_roll_dice_timer_timeout() -> void:
	animation_player.stop()
	if dice_state != DiceStates.LOCK:
		dice_state = DiceStates.IDLE
	roll_complete.emit()

 
