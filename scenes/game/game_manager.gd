class_name GameManager
extends Node2D

const BATTLE_MANAGER = preload("res://scenes/game/managers/battle_manager/battle_manager.tscn")

@onready var player_manager: PlayerManager = %PlayerManager
@onready var dice_calculator: DiceCalculator = %DiceCalculator

@onready var top_bar_ui: TopBarUI = %TopBarUI

@onready var battle_ui_layer: CanvasLayer = %BattleUILayer
var battle_manager : BattleManager

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
	_switch_state(ManagerStates.START_STAGE)

func _switch_state(new_state : ManagerStates) -> void:
	
	manager_state = new_state
	
	match manager_state:
		ManagerStates.START_STAGE:
			battle_manager = BATTLE_MANAGER.instantiate()
			battle_ui_layer.add_child(battle_manager)
			
			battle_manager.start_battle(player_manager,dice_calculator)
