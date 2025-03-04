class_name BattleManager
extends Control


enum BattleStates {
	START,
	PLAYER_TURN,
	PLAYER_ATTACK,
	ENEMY_TURN,
	ENEMY_ATTACK,
	ENEMY_LOST,
	PLAYER_LOST
}

var battle_state : BattleStates = BattleStates.START

var player_manager: PlayerManager
var dice_calculator: DiceCalculator

@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var player_dice_ui: PlayerDiceUI = %PlayerDiceUI
@onready var enemy_info_ui: EnemyInfoUI = %EnemyInfoUI
@onready var enemy_dice_ui: EnemyDiceUI = %EnemyDiceUI
@onready var battle_stage_3d: BattleStage3D = %BattleStage3D

var player_attack_score : int = 0
var enemy_attack_score : int = 0

signal state_changed(state : BattleStates)
signal player_victory
signal player_defeat

func _ready() -> void:
	ItemHelper.battle_manager = self

func preparate_manager(player_manager_instance : PlayerManager, dice_calculator_instance : DiceCalculator) -> void:
	player_manager = player_manager_instance
	dice_calculator = dice_calculator_instance
	
	player_manager.player_died.connect(_on_player_manager_player_died)
	enemy_manager.enemy_died.connect(_on_enemy_manager_enemy_died)

func start_battle(new_enemy : Enemy) -> void:
	enemy_manager.preparate_new_enemy(new_enemy)
	_change_state(BattleStates.START)
	

func _change_state(new_state : BattleStates) -> void:

	battle_state = new_state
	
	match battle_state:
		BattleStates.START:
			battle_stage_3d.start_intro()
			battle_stage_3d.set_enemy_sprite(enemy_manager.enemy_texture)
			player_dice_ui.set_rolls_left(player_manager.rolls)
			enemy_dice_ui.set_dice_ammount(enemy_manager.dice_ammount)
			enemy_info_ui.set_enemy_name_description(enemy_manager.enemy_name, enemy_manager.enemy_description)
			enemy_info_ui.set_enemy_health_info(enemy_manager.health,enemy_manager.max_health)
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			enemy_info_ui.hide()
		BattleStates.PLAYER_TURN:
			enemy_info_ui.show()
			battle_stage_3d.player_turn()
			player_dice_ui.show()
			player_dice_ui.reset_player_UI(player_manager.rolls)
			enemy_dice_ui.hide()
		BattleStates.PLAYER_ATTACK:
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
			battle_stage_3d.player_attack()
		BattleStates.ENEMY_TURN:
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.show()
			enemy_dice_ui.roll_dice()
		BattleStates.ENEMY_ATTACK:
			battle_stage_3d.enemy_attack()
			enemy_info_ui.show()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
		BattleStates.ENEMY_LOST:
			battle_stage_3d.enemy_dead()
			enemy_info_ui.hide()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
		BattleStates.PLAYER_LOST:
			battle_stage_3d.player_dead()
			enemy_info_ui.hide()
			player_dice_ui.hide()
			enemy_dice_ui.hide()
	
	ItemHelper.on_battle_manager_status_change.emit(battle_state)

func _on_player_dice_ui_dice_roll_finished(dice_values: Dictionary[String,int]) -> void:
	player_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)

	for dice : String in dice_values:
		player_attack_score += dice_values[dice]

	player_attack_score *= dice_calculator.dice_combos_scores[dice_combo]

	player_dice_ui.set_attack_score_label(player_attack_score)
	player_dice_ui.show_dice_combo(dice_combo,dice_calculator.dice_combos_scores[dice_combo])

func _on_player_dice_ui_player_attack() -> void:
	_change_state(BattleStates.PLAYER_ATTACK)

func _on_enemy_dice_ui_dice_roll_finished(dice_values: Dictionary[String, int]) -> void:
	enemy_attack_score = 0
	var dice_combo : DiceCalculator.DiceComboNames = dice_calculator.check_for_dice_combos(dice_values)

	for dice : String in dice_values:
		enemy_attack_score += dice_values[dice]

	enemy_attack_score *= dice_calculator.dice_combos_scores[dice_combo]

	enemy_dice_ui.show_enemy_attack_score(dice_combo,enemy_attack_score)
	await get_tree().create_timer(2).timeout
	_change_state(BattleStates.ENEMY_ATTACK)


func _on_battle_stage_3d_battle_ready() -> void:
	_change_state(BattleStates.PLAYER_TURN)


func _on_battle_stage_3d_enemy_dying_animation_finished() -> void:
	player_victory.emit()


func _on_battle_stage_3d_player_dying_animation_finished() -> void:
	get_tree().reload_current_scene()


func _on_battle_stage_3d_enemy_just_attacked() -> void:
	player_manager.update_health(-enemy_attack_score)
	
	if player_manager.health > 0:
		_change_state(BattleStates.PLAYER_TURN)


func _on_battle_stage_3d_player_just_attacked() -> void:
	enemy_manager.update_health(-player_attack_score)
	
	enemy_info_ui.set_enemy_health_info(enemy_manager.health,enemy_manager.max_health)
	
	if enemy_manager.health > 0:
		_change_state(BattleStates.ENEMY_TURN)


func _on_enemy_manager_enemy_died() -> void:
	await get_tree().create_timer(1.0).timeout
	ItemHelper.on_enemy_died.emit()
	_change_state(BattleStates.ENEMY_LOST)

func _on_player_manager_player_died() -> void:
	await get_tree().create_timer(1.0).timeout
	_change_state(BattleStates.PLAYER_LOST)
