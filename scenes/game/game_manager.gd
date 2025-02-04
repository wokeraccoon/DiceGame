class_name GameManager
extends Node2D



@onready var dice_calculator: DiceCalculator = $DiceCalculator
@onready var battle_stage: BattleStage = %BattleStage

@onready var player_dice_ui: PlayerDiceUI = %PlayerDiceUI

var player_attack_score : int = 0

signal restart_run

func _on_player_dice_ui_dice_roll_finished(dice_values: Dictionary[String,int]) -> void:
	player_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	for dice : String in dice_values:
		player_attack_score += dice_values[dice]
		
	player_attack_score *= dice_calculator.dice_combos_scores[dice_combo]
	
	player_dice_ui.set_attack_score_label(player_attack_score)
	player_dice_ui.show_dice_combo(dice_combo)
