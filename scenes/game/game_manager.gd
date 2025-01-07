class_name GameManager
extends Node2D

var dice_combos_scores : Dictionary = {
	"Singles" : 1,
	"Pair" : 5,
	"Two Pair" : 10,
	"Three of a Kind" : 15,
	"Four of a Kind" : 30,
	"Full House" : 25,
	"Straight" : 35,
	"Yatch" : 100
}

enum GameStates {
	RUN_START,
	EXPLORING,
	OPEN_CHEST,
	STORE,
	FIGHT,
	RUN_LOST
}

var games_state : GameStates = GameStates.RUN_START

var player_class : PlayerClass

var current_enemy : Enemy

var score_to_defeat_enemy : int  = 1000
var attacks_left : int = 3
var rolls_left : int = 3


var player_weapon : Weapon
var player_inventory : Array[Item]

var dice_hand_score : int = 0
var dice_hand_combo : String = ""

signal restart_run

#in fight screen stuff

@onready var dice_area: DiceAreaUI = %DiceArea
@onready var player_stats_ui: PlayerStatsUI = %PlayerStatsUI
@onready var enemy_stats_ui: EnemyStatsUI = %EnemyStatsUI

func count_value_occurrences_concise(my_dictionary: Dictionary, target_value) -> int:
	return my_dictionary.values().count(target_value)

func check_for_dice_combos(dice_rolled : Dictionary) -> void:
	dice_hand_combo = ""
	var dice_sides_ammounts : Dictionary = {}

	for dice_value in 6:
		dice_value += 1
		var ocurrences = count_value_occurrences_concise(dice_rolled,dice_value)
		if ocurrences > 0:
			dice_sides_ammounts[dice_value] = ocurrences

	#yatch
	if dice_sides_ammounts.size() == 1:
		dice_hand_combo = "Yatch"
	
	#straights
	if dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5) and dice_sides_ammounts.has(6):
		dice_hand_combo = "Straight"
		
	if dice_sides_ammounts.has(1) and dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5):
		dice_hand_combo = "Straight"

	#full house or four on a row
	if dice_sides_ammounts.size() == 2:

		var set_one : int = dice_sides_ammounts[dice_sides_ammounts.keys()[0]]
		var set_two : int = dice_sides_ammounts[dice_sides_ammounts.keys()[1]]
		
		#full house
		if set_one == 2 and set_one == 3:
			dice_hand_combo = "Full House"
		elif set_two == 2 or set_two == 3:
			dice_hand_combo = "Full House"

		#four on a row
		if set_one == 4:
			dice_hand_combo = "Four of a Kind"
		elif set_two == 4:
			dice_hand_combo = "Four of a Kind"

	else:
		#pair, two pair, and tree of a kind
		var pair_ammount : int = 0
		var has_trio : bool = false

		for i in dice_sides_ammounts.keys().size():
			if dice_sides_ammounts[dice_sides_ammounts.keys()[i]] == 2:
				pair_ammount += 1
			if dice_sides_ammounts[dice_sides_ammounts.keys()[i]] == 3:
				has_trio = true

		if pair_ammount == 1:
			dice_hand_combo = "Pair"
		elif pair_ammount == 2:
			dice_hand_combo = "Two Pair"
		elif has_trio:
			dice_hand_combo = "Three of a Kind"
	
	#single dice
	var single_dice_value : int = 0
	for dice in dice_rolled:
		single_dice_value += dice_rolled[dice]
	
	dice_hand_score = single_dice_value
	
	if dice_hand_combo == "":
		dice_hand_combo = "Singles"
	else:
		dice_hand_score *= dice_combos_scores[dice_hand_combo]

func _process(_delta: float) -> void:
	player_stats_ui.attacks_label.text = str(attacks_left)
	player_stats_ui.rolls_label.text = str(rolls_left)
	
	enemy_stats_ui.defeat_points_label.text = str(score_to_defeat_enemy)

func _on_dice_area_roll_started() -> void:
	rolls_left -= 1
	player_stats_ui.attack_score_label.text = "0"
	player_stats_ui.dice_combo_label.text = "Rolling..."
	dice_area.roll_dice()

func _on_dice_area_roll_finished(dice_data: Dictionary) -> void:
	check_for_dice_combos(dice_data)
	dice_area.attack_button.disabled = false
	if rolls_left == 0:
		dice_area.roll_dice_button.disabled = true
	
	player_stats_ui.attack_score_label.text = str(dice_hand_score)
	player_stats_ui.dice_combo_label.text = dice_hand_combo

@onready var fight_lost_screen: Panel = %FightLostScreen
@onready var fight_won_screen: Panel = %FightWonScreen

func _on_dice_area_attack_requested() -> void:
	score_to_defeat_enemy -= dice_hand_score
	dice_area.roll_dice_button.disabled = false
	dice_area.attack_button.disabled = true
	attacks_left -= 1
	rolls_left = 3
	
	if attacks_left == 0 and score_to_defeat_enemy > 0:
		fight_lost_screen.show()
		dice_area.roll_dice_button.disabled = true
		dice_area.attack_button.disabled = true
	
	if score_to_defeat_enemy <= 0:
		fight_won_screen.show()
		dice_area.roll_dice_button.disabled = true
		dice_area.attack_button.disabled = true
	
	dice_area.reset_all_dice()
	player_stats_ui.attack_score_label.text = "0"
	player_stats_ui.dice_combo_label.text = ""


#options menu stuff
@onready var options_menu_ui: OptionsMenuUI = %OptionsMenuUI

func _on_options_button_pressed() -> void:
	options_menu_ui.visible = true

func _on_options_menu_ui_main_menu_requested() -> void:
	get_tree().reload_current_scene()

func _on_options_menu_ui_restart_run_requested() -> void:
	restart_run.emit()

#reference menu stuff
@onready var reference_menu_ui: Control = %ReferenceMenuUI

func _on_reference_button_pressed() -> void:
	reference_menu_ui.visible = true
