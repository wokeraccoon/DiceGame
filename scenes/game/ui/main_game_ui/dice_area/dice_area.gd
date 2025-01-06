class_name DiceAreaUI
extends MarginContainer

@onready var roll_dice_button: Button = %RollDiceButton
@onready var attack_button: Button = %AttackButton

var game_manager : GameManager

@export var dices : Array[Dice]

var current_dice_numbers : Dictionary = {}
var is_first_roll : bool = true


signal roll_started
signal roll_finished(dice_data : Dictionary)

signal attack_requested

func _ready() -> void:
	for dice : Dice in dices:
		dice.roll_finished.connect(_on_dice_roll_finished)


var dice_ammount : int = 0

func reset_all_dice() -> void:
	is_first_roll = true
	for dice : Dice in dices:
		dice.reset_dice()


func _on_dice_roll_finished() -> void:
	dice_ammount += 1
	
	if dice_ammount == 5:
		roll_dice_button.disabled = false
		
		for dice : Dice in dices:
			current_dice_numbers[dice.name] = dice.current_number
		
		roll_finished.emit(current_dice_numbers)
	

func _on_roll_dice_button_pressed() -> void:
	if is_first_roll:
		reset_all_dice()
		is_first_roll = false
	roll_started.emit()

func roll_dice() -> void:
	for dice : Dice in dices:
		dice_ammount = 0
		current_dice_numbers.clear()
		roll_dice_button.disabled = true
		dice.roll_dice()


func _on_attack_button_pressed() -> void:
	attack_requested.emit()
