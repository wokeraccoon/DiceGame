extends Node

var battle_manager : BattleManager = null
var player_dice_ui : PlayerDiceUI = null

signal on_battle_manager_status_change(states : BattleManager.BattleStates)
signal on_player_dice_ui_roll_completed()
