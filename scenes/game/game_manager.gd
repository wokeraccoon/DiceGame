class_name GameManager
extends Node2D

@onready var player_manager: PlayerManager = %PlayerManager
@onready var dice_calculator: DiceCalculator = %DiceCalculator
@onready var options_top_bar_ui: OptionsTopBarUI = %OptionsTopBarUI
@onready var battle_manager: BattleManager = %BattleManager
@onready var inventory_ui: InventoryUI = %InventoryUI

@export var current_enemy_pool : EnemyPool

enum ManagerStates {
	START_STAGE,
	CHOOSE_PATH,
	BATTLE,
	SHOP_KEEPER,
	CHEST,
	BOSS_BATTLE,
	FAILED_STAGE,
	COMPLETED_STAGE
}

var manager_state : ManagerStates = ManagerStates.START_STAGE

func _ready() -> void:
	ItemHelper.game_manager = self
	ItemHelper.player_manager = player_manager
	ItemHelper.inventory_ui = inventory_ui
	_switch_state(ManagerStates.START_STAGE)

func _switch_state(new_state : ManagerStates) -> void:
	
	manager_state = new_state
	
	match manager_state:
		ManagerStates.START_STAGE:
			battle_manager.preparate_manager(player_manager,dice_calculator)
			#_switch_state(ManagerStates.BATTLE)
		ManagerStates.BATTLE:
			battle_manager.show()
			battle_manager.start_battle(current_enemy_pool.request_enemy_from_pool(Enemy.EnemyTypes.EARLY_LEVEL))


func _on_battle_manager_player_victory() -> void:
	_switch_state(ManagerStates.BATTLE)
