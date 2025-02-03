class_name GameManager
extends Node2D



@onready var dice_calculator: DiceCalculator = $DiceCalculator
@onready var battle_stage: BattleStage = %BattleStage

@onready var player_dice_ui: PlayerDiceUI = %PlayerDiceUI

signal restart_run

func _on_player_dice_ui_dice_roll_finished(dice_values: Dictionary[String,int]) -> void:
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	player_dice_ui.show_dice_combo(dice_combo)
