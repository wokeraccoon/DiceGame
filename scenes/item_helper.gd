extends Node

var game_manager : GameManager = null
var inventory_ui : InventoryUI = null
var battle_manager : BattleManager = null
var player_manager : PlayerManager = null
var player_dice_ui : PlayerDiceUI = null

signal on_battle_manager_status_change(states : BattleManager.BattleStates)
signal on_player_dice_ui_roll_completed
signal on_enemy_died
