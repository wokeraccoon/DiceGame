class_name Dice
extends Control


@onready var dice_texture: TextureRect = $DiceTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dice_button: Button = %DiceButton

@export var dice_array_textures : Array[Texture2D] = []
@export var alt_dice_array_textures : Array[Texture2D] = []

enum DiceStates {
	INTRO,
	IDLE,
	ROLL,
	LOCK,
	UNLOCK,
	OUTRO,
	DECORATIVE
}

@export var dice_state : DiceStates = DiceStates.INTRO
@export var use_alt_dice : bool = false

enum DiceOwners {
	ENEMY,
	PLAYER
}

@export var dice_owner : DiceOwners = DiceOwners.PLAYER

@export_range(1,6) var dice_value : int = 1
@export var is_decorative : bool = false

signal roll_complete

func _ready() -> void:
	if Engine.is_editor_hint() == false:
		
		if is_decorative:
			set_number()
			_switch_state(DiceStates.DECORATIVE)

func _switch_state(state : DiceStates) -> void:
	
	dice_state = state
	
	match state:
		DiceStates.INTRO:
			dice_button.button_pressed = false
			dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			animation_player.play("DICE_INTRO")
			await animation_player.animation_finished
			_switch_state(DiceStates.ROLL)
			
			
		DiceStates.ROLL:
			dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			if !dice_button.button_pressed:
				for i in randi_range(8,12):
					animation_player.play("DICE_ROLL")
					
					await animation_player.animation_finished
					dice_value = randi_range(1,6)
					if use_alt_dice:
						dice_texture.texture = alt_dice_array_textures[dice_value - 1]
					else:
						dice_texture.texture = dice_array_textures[dice_value - 1]
			else:
				await get_tree().create_timer(randi_range(1,2)).timeout

			roll_complete.emit()
			_switch_state(DiceStates.IDLE)
			
		DiceStates.IDLE:
			if dice_owner ==  DiceOwners.PLAYER:
				dice_button.mouse_filter = Control.MOUSE_FILTER_STOP
			else:
				dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			if !dice_button.button_pressed:
				animation_player.play("DICE_IDLE")
			
		DiceStates.LOCK:
			dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			animation_player.play("DICE_LOCK")
			await animation_player.animation_finished
			_switch_state(DiceStates.IDLE)

		DiceStates.UNLOCK:
			dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			animation_player.play("DICE_UNLOCK")
			await animation_player.animation_finished
			_switch_state(DiceStates.IDLE)
		
		DiceStates.DECORATIVE:
			dice_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			animation_player.play("DICE_IDLE")
			dice_button.focus_mode = Control.FOCUS_NONE

func set_number() -> void:
	if use_alt_dice:
		dice_texture.texture = alt_dice_array_textures[dice_value - 1]
	else:
		dice_texture.texture = dice_array_textures[dice_value - 1]

func start_roll_dice() -> void:
	_switch_state(DiceStates.ROLL)

func restart_dice() -> void:
	_switch_state(DiceStates.INTRO)

func _on_dice_button_pressed() -> void:
	
	if dice_button.button_pressed:
		_switch_state(DiceStates.LOCK)
	else:
		_switch_state(DiceStates.UNLOCK)
