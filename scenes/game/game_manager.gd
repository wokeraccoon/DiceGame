class_name GameManager
extends Node2D

enum GameStates {
	PLAYER_TURN,
	ENEMY_TURN,
	DEAD,
	WIN
}

var game_state : GameStates = GameStates.PLAYER_TURN

const FLOATING_TEXT = preload("res://gui_assets/floating_text/floating_text.tscn")


@onready var player_manager: PlayerManager = $PlayerManager
@onready var dice_calculator: DiceCalculator = $DiceCalculator
@onready var battle_stage: BattleStage = %BattleStage
@onready var player_dice_ui: PlayerDiceUI = %PlayerDiceUI
@onready var top_bar_ui: TopBarUI = %TopBarUI
@onready var enemy_info_ui: EnemyInfoUI = %EnemyInfoUI
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var enemy_damage_text_spawner: Control = %EnemyDamageTextSpawner
@onready var enemy_dice_ui: EnemyDiceUI = %EnemyDiceUI

var player_attack_score : int = 0
var enemy_attack_score : int = 0


func _ready() -> void:
	player_dice_ui.set_rolls_left(player_manager.rolls)
	top_bar_ui.update_health(player_manager.health,player_manager.max_health)
	top_bar_ui.update_money(player_manager.money)
	enemy_info_ui.set_enemy_name_description(enemy_manager.enemy_resource.name, enemy_manager.enemy_resource.short_description)
	enemy_info_ui.set_enemy_health_info(enemy_manager.health,enemy_manager.max_health)

func _on_player_dice_ui_dice_roll_finished(dice_values: Dictionary[String,int]) -> void:
	player_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	for dice : String in dice_values:
		player_attack_score += dice_values[dice]
		
	player_attack_score *= dice_calculator.dice_combos_scores[dice_combo]
	
	player_dice_ui.set_attack_score_label(player_attack_score)
	player_dice_ui.show_dice_combo(dice_combo,dice_calculator.dice_combos_scores[dice_combo])

func _on_player_dice_ui_player_attack() -> void:
	battle_stage.hit_enemy()
	await get_tree().create_timer(1).timeout
	var floating_text : FloatingText = FLOATING_TEXT.instantiate()
	enemy_damage_text_spawner.add_child(floating_text)
	floating_text.set_floating_text(str(player_attack_score),floating_text.ColorPresets.ENEMY_DAMAGE)
	enemy_manager.health -= player_attack_score


func _on_battle_stage_player_turn() -> void:
	enemy_info_ui.show()
	await get_tree().create_timer(0.25).timeout
	player_dice_ui.show()
	player_dice_ui.roll_dice(true)

func _on_battle_stage_enemy_turn() -> void:
	enemy_dice_ui.show()
	enemy_dice_ui.roll_dice(enemy_manager.dice_ammount)



func _on_enemy_dice_ui_dice_roll_finished(dice_values: Dictionary[String, int]) -> void:
	enemy_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	for dice : String in dice_values:
		enemy_attack_score += dice_values[dice]
		
	enemy_attack_score *= dice_calculator.dice_combos_scores[dice_combo]
	
	enemy_dice_ui.show_enemy_attack_score(dice_combo,enemy_attack_score)
