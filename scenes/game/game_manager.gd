class_name GameManager
extends Node2D

const DICE = preload("res://dice/dice.tscn")

@onready var dice_calculator: DiceCalculator = $DiceCalculator
@onready var battle_stage: BattleStage = %BattleStage

@onready var player_dice_holder: HBoxContainer = %PlayerDiceHolder
@onready var roll_button: Button = %RollButton
@onready var attack_button: Button = %AttackButton

@export var players_dice : Array[Dice] = []

signal restart_run

func _ready() -> void:
	battle_stage.battle_stage_ready.connect(_on_battle_stage_ready)
	roll_button.hide()
	attack_button.hide()
	
func _on_battle_stage_ready() -> void:
	
	for i in 5:
		await get_tree().create_timer(0.25).timeout
		var dice : Dice = DICE.instantiate()
		player_dice_holder.add_child(dice)
		dice.connect("roll_complete",on_dice_roll_complete)
		players_dice.append(dice)
	
	await get_tree().create_timer(0.25).timeout
	roll_button.show()
	attack_button.show()
	roll_button.disabled = true
	attack_button.disabled = true

var dice_rolled : int = 0

func on_dice_roll_complete(number : int) -> void:
	dice_rolled += 1
	
	if dice_rolled == 5:
		roll_button.disabled = false
		attack_button.disabled = false
		
		roll_button.grab_focus()

func _on_roll_button_pressed() -> void:
	dice_rolled = 0
	
	for dice : Dice in players_dice:
		dice.start_roll_dice()
	
	roll_button.disabled = true
	attack_button.disabled = true
