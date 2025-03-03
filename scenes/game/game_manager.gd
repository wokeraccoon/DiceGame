class_name GameManager
extends Node2D

@onready var player_manager: PlayerManager = %PlayerManager
@onready var dice_calculator: DiceCalculator = %DiceCalculator
@onready var options_top_bar_ui: OptionsTopBarUI = %OptionsTopBarUI
@onready var battle_manager: BattleManager = %BattleManager
@onready var item_particles: CPUParticles2D = %ItemParticles
@onready var inventory_ui: InventoryUI = %InventoryUI

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
			battle_manager.start_battle(player_manager,dice_calculator)
			
