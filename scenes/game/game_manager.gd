class_name GameManager
extends Node2D

@onready var player_manager: PlayerManager = %PlayerManager
@onready var dice_calculator: DiceCalculator = %DiceCalculator
@onready var top_bar_ui: TopBarUI = %TopBarUI
@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var battle_manager : BattleManager = %BattleManager

func _ready() -> void:
	battle_manager.start_battle()
