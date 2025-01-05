class_name DiceAreaUI
extends MarginContainer

@onready var reroll_dice_button: Button = %RerollDiceButton
@onready var attack_button: Button = %AttackButton

var game_manager : GameManager

@export var dices : Array[Dice]

var current_dice_numbers : Dictionary = {}

signal all_dice_rolled(dice_data : Dictionary)

func _ready() -> void:
	for dice : Dice in dices:
		dice.roll_finished.connect(_on_dice_roll_finished)

func _on_reroll_dice_button_pressed() -> void:
	
	for dice : Dice in dices:
		dice_ammount = 0
		current_dice_numbers.clear()
		reroll_dice_button.disabled = true
		dice.roll_dice()

var dice_ammount : int = 0

func unlock_all_dice() -> void:
	for dice : Dice in dices:
		if dice.is_locked:
			dice._on_lock_button_pressed()


func _on_dice_roll_finished() -> void:
	dice_ammount += 1
	
	if dice_ammount == 5:
		reroll_dice_button.disabled = false
		
		for dice : Dice in dices:
			current_dice_numbers[dice.name] = dice.current_number
		
		all_dice_rolled.emit(current_dice_numbers)
	
