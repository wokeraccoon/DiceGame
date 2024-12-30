class_name Game
extends Node2D

@onready var stats_ui_layer: CanvasLayer = $StatsUILayer
@onready var item_picker_layer: CanvasLayer = $ItemPickerLayer

const ITEM_PICKER = preload("res://scenes/game/ui/item_picker/item_picker.tscn")

enum DiceCombosNames {
	SINGLE,
	PAIR,
	TWO_PAIR,
	THREE_OF_A_KIND,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	STRAIGHT,
	YATCH
}

var player_class : PlayerClass

var player_health : int = 0
var player_money : int = 0

var current_dice_hand : Dictionary = {
	"dice_one" : 1,
	"dice_two" : 1,
	"dice_three" : 1,
	"dice_four" : 1,
	"dice_five" : 1,
}

var current_dice_combos_on_hand : Dictionary = {}
var total_dice_hand_score : float = 0

var current_enemy : Enemy

var enemy_health : int = 0
var enemy_reward_money : int = 0

enum GameStates {
	RUN_START,
	EXPLORING,
	OPEN_CHEST,
	STORE,
	FIGHT,
	RUN_LOST
}

var games_state : GameStates = GameStates.RUN_START

var player_weapon : Weapon
var player_inventory : Array[Item]


func count_value_occurrences_concise(my_dictionary: Dictionary, target_value) -> int:
	return my_dictionary.values().count(target_value)

func check_for_dice_combos(dice_rolled : Dictionary) -> int:
	
	var current_dice_hand_score : int = 0
	var dice_sides_ammounts : Dictionary = {}

	for dice_value in 6:
		dice_value += 1
		var ocurrences = count_value_occurrences_concise(dice_rolled,dice_value)
		if ocurrences > 0:
			dice_sides_ammounts[dice_value] = ocurrences

	#yatch
	if dice_sides_ammounts.size() == 1:
		current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.YATCH]] = 50
	
	#straights
	if dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5) and dice_sides_ammounts.has(6):
		current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.STRAIGHT]] = 35
		
	if dice_sides_ammounts.has(1) and dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5):
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.STRAIGHT]] = 35

	#full house or four on a row
	if dice_sides_ammounts.size() == 2:

		var set_one : int = dice_sides_ammounts[dice_sides_ammounts.keys()[0]]
		var set_two : int = dice_sides_ammounts[dice_sides_ammounts.keys()[1]]
		
		#full house
		if set_one == 2 or set_one == 3:
			if set_two == 2 or set_two == 3:
				current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.FULL_HOUSE]] = 25

		#four on a row
		if set_one == 4:
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.FOUR_OF_A_KIND]] = 30
		elif set_two == 4:
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.FOUR_OF_A_KIND]] = 30

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
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.PAIR]] = 5
		elif pair_ammount == 2:
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.TWO_PAIR]] = 10
		elif has_trio:
			current_dice_combos_on_hand[DiceCombosNames.keys()[DiceCombosNames.THREE_OF_A_KIND]] = 15
	
	#single dice
	var single_dice_value : int = 0
	for dice in current_dice_hand:
		single_dice_value += current_dice_hand[dice]
	
	current_dice_hand_score = single_dice_value
	
	if current_dice_combos_on_hand.size() != 0:
		current_dice_hand_score *= current_dice_combos_on_hand[current_dice_combos_on_hand.keys()[0]]
	
	return current_dice_hand_score

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept") == true:
		get_tree().reload_current_scene()
