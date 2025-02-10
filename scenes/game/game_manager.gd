class_name GameManager
extends Node2D

const FLOATING_TEXT = preload("res://gui_assets/floating_text/floating_text.tscn")

enum GameStates {
	START,
	PLAYER_TURN,
	PLAYER_ATTACK,
	ENEMY_TURN,
	ENEMY_ATTACK,
	ENEMY_LOST,
	PLAYER_LOST
}

var game_state : GameStates = GameStates.START

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
	enemy_dice_ui.set_dice_ammount(enemy_manager.dice_ammount)
	top_bar_ui.update_health(player_manager.health,player_manager.max_health)
	top_bar_ui.update_money(player_manager.money)
	enemy_info_ui.set_enemy_name_description(enemy_manager.enemy_resource.name, enemy_manager.enemy_resource.short_description)
	enemy_info_ui.set_enemy_health_info(enemy_manager.health,enemy_manager.max_health)
	
	_change_state(GameStates.START)
	
func _change_state(new_state : GameStates) -> void:
	
	game_state = new_state
	
	match new_state:
		GameStates.START:
			battle_stage.start_intro()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			enemy_info_ui.hide()
		GameStates.PLAYER_TURN:
			enemy_info_ui.show()
			battle_stage.player_turn()
			player_dice_ui.show()
			player_dice_ui.reset_player_UI(player_manager.rolls)
			enemy_dice_ui.hide()
		GameStates.PLAYER_ATTACK:
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			battle_stage.player_attack()
		GameStates.ENEMY_TURN:
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.show()
			enemy_dice_ui.roll_dice()
		GameStates.ENEMY_ATTACK:
			battle_stage.enemy_attack()
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
		GameStates.ENEMY_LOST:
			battle_stage.enemy_dead()
			enemy_info_ui.hide()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			top_bar_ui.hide()
		GameStates.PLAYER_LOST:
			battle_stage.player_dead()
			enemy_info_ui.hide()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			top_bar_ui.hide()

func _on_player_dice_ui_dice_roll_finished(dice_values: Dictionary[String,int]) -> void:
	player_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	for dice : String in dice_values:
		player_attack_score += dice_values[dice]
		
	player_attack_score *= dice_calculator.dice_combos_scores[dice_combo]
	
	player_dice_ui.set_attack_score_label(player_attack_score)
	player_dice_ui.show_dice_combo(dice_combo,dice_calculator.dice_combos_scores[dice_combo])

func _on_player_dice_ui_player_attack() -> void:
	_change_state(GameStates.PLAYER_ATTACK)

func _on_enemy_dice_ui_dice_roll_finished(dice_values: Dictionary[String, int]) -> void:
	enemy_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)
	
	for dice : String in dice_values:
		enemy_attack_score += dice_values[dice]
		
	enemy_attack_score *= dice_calculator.dice_combos_scores[dice_combo]
	
	enemy_dice_ui.show_enemy_attack_score(dice_combo,enemy_attack_score)
	await get_tree().create_timer(2).timeout
	_change_state(GameStates.ENEMY_ATTACK)
	

func _on_battle_stage_battle_ready() -> void:
	_change_state(GameStates.PLAYER_TURN)


func _on_battle_stage_player_attacked() -> void:
	var floating_text : FloatingText = FLOATING_TEXT.instantiate()
	enemy_damage_text_spawner.add_child(floating_text)
	floating_text.set_floating_text(str(player_attack_score),floating_text.ColorPresets.ENEMY_DAMAGE)
	enemy_manager.health -= player_attack_score
	enemy_info_ui.set_enemy_health_info(enemy_manager.health,enemy_manager.max_health)
	await get_tree().create_timer(1).timeout
	
	if enemy_manager.health <= 0:
		_change_state(GameStates.ENEMY_LOST)
	else:
		_change_state(GameStates.ENEMY_TURN)


func _on_battle_stage_enemy_attacked() -> void:
	player_manager.health -= enemy_attack_score
	top_bar_ui.update_health(player_manager.health, player_manager.max_health)
	await get_tree().create_timer(1).timeout
	
	if player_manager.health <= 0:
		_change_state(GameStates.PLAYER_LOST)
	else:
		_change_state(GameStates.PLAYER_TURN)


func _on_battle_stage_enemy_died() -> void:
	get_tree().reload_current_scene()


func _on_battle_stage_player_died() -> void:
	get_tree().reload_current_scene()
