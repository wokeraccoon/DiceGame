class_name PlayerDiceUI
extends Control

const DICE: PackedScene = preload("res://dice/dice.tscn")

@onready var player_dice_holder: HBoxContainer = %PlayerDiceHolder
@onready var roll_button: Button = %RollButton
@onready var attack_button: Button = %AttackButton
@onready var scoring_area: HBoxContainer = %ScoringArea
@onready var top_bar_ui: MarginContainer = %TopBarUI

@export var player_dice : Array[Dice] = []

signal dice_roll_finished(dice_values : Dictionary[String,int])

func _ready() -> void:
	
	
	roll_button.hide()
	attack_button.hide()
	scoring_area.hide()
	
	_on_battle_stage_ready()
	
func _on_battle_stage_ready() -> void:
	
	for i in 5:
		await get_tree().create_timer(0.25).timeout
		var dice : Dice = DICE.instantiate()
		player_dice_holder.add_child(dice)
		dice.connect("roll_complete",on_dice_roll_complete)
		player_dice.append(dice)
		
	
	await get_tree().create_timer(0.25).timeout
	dice_hand_label.text = "[shake rate=20.0 level=5 connected=1][font_size=48]Rolling...[/font_size][/shake]"
	roll_button.show()
	attack_button.show()
	scoring_area.show()
	roll_button.disabled = true
	attack_button.disabled = true
	

var dice_rolled : int = 0

func on_dice_roll_complete(_number : int) -> void:
	dice_rolled += 1
	
	if dice_rolled == 5:
		dice_rolled = 0
		roll_button.disabled = false
		attack_button.disabled = false
		
		roll_button.grab_focus()
		
		var dice_values : Dictionary[String,int] = {}
		
		for dice in player_dice.size():
			dice_values[str("Dice",dice)] = player_dice[dice].dice_value
			
		dice_roll_finished.emit(dice_values)
		
		
@onready var dice_hand_label: RichTextLabel = %DiceHandLabel

func show_dice_combo(dice_combo : DiceCalculator.DiceComboNames) -> void:
	
	match dice_combo:
		DiceCalculator.DiceComboNames.SINGLES:
			dice_hand_label.text = "[font_size=48]Singles (1)[/font_size]"
		DiceCalculator.DiceComboNames.PAIR:
			dice_hand_label.text = "[font_size=48]Pair (5)[/font_size]"
		DiceCalculator.DiceComboNames.TWO_PAIR:
			dice_hand_label.text = "[font_size=48]Two Pair (10)[/font_size]"
		DiceCalculator.DiceComboNames.THREE_OF_A_KIND:
			dice_hand_label.text = "[font_size=48]Three of a kind (20)[/font_size]"
		DiceCalculator.DiceComboNames.FOUR_OF_A_KIND:
			dice_hand_label.text = "[font_size=48]Four of a kind (30)[/font_size]"
		DiceCalculator.DiceComboNames.FULL_HOUSE:
			dice_hand_label.text = "[font_size=48]Full house (25)[/font_size]"
		DiceCalculator.DiceComboNames.STRAIGHT:
			dice_hand_label.text = "[font_size=48]Straight (35)[/font_size]"
		DiceCalculator.DiceComboNames.YATCH:
			dice_hand_label.text = "[rainbow sat=0.5][wave amp=100 freq=5][font_size=48]Yatch! (50)[/font_size][/wave][/rainbow]"

func _on_roll_button_pressed() -> void:
	
	dice_hand_label.text = "[shake rate=20.0 level=5 connected=1][font_size=48]Rolling...[/font_size][/shake]"
	
	for dice : Dice in player_dice:
		dice.start_roll_dice()
	
	roll_button.disabled = true
	attack_button.disabled = true
