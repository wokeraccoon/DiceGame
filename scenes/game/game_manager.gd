class_name GameManager
extends Node2D

@onready var player_manager: PlayerManager = %PlayerManager
@onready var dice_calculator: DiceCalculator = %DiceCalculator

@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var battle_manager : BattleManager = %BattleManager

@onready var top_bar_ui: TopBarUI = %TopBarUI

@onready var battle_screen : CanvasLayer = %BattleScreen

enum StageStates {
	START_STAGE,
	CHOOSE_PATH,
	BATTLE,
	SHOP_KEEPER,
	CHEST,
	BOSS_BATTLE,
	FAILED_STAGE,
	COMPLETED_STAGE
}


func _ready() -> void:
	pass
