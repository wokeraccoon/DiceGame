class_name Game
extends Node2D

@onready var stats_ui_layer: CanvasLayer = $StatsUILayer
@onready var item_picker_layer: CanvasLayer = $ItemPickerLayer

const ITEM_PICKER = preload("res://scenes/game/ui/item_picker/item_picker.tscn")

enum DiceCombos {
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

func _ready() -> void:
	print("")
	var current_dice : int = 1
	for dice in current_dice_hand:
		current_dice_hand[dice] = randi_range(1,6)
		print(str("Dice ",current_dice,": ",current_dice_hand[dice]))
		current_dice += 1

	print(" ")
	check_for_dice_combos(current_dice_hand)

func count_value_occurrences_concise(my_dictionary: Dictionary, target_value) -> int:
	return my_dictionary.values().count(target_value)


func check_for_dice_combos(dice_rolled : Dictionary) -> void:

	var dice_sides_ammounts : Dictionary = {

	}

	for dice_value in 6:
		dice_value += 1
		var ocurrences = count_value_occurrences_concise(dice_rolled,dice_value)
		if ocurrences > 0:
			dice_sides_ammounts[dice_value] = ocurrences

	print(dice_sides_ammounts)

	#yatch
	if dice_sides_ammounts.size() == 1:
		print("Yatch!")

	elif dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5) and dice_sides_ammounts.has(6):
		print("Large Straight!")

	elif dice_sides_ammounts.has(1) and dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5):
			print("Little Straight!")

	#full house or four on a row
	elif dice_sides_ammounts.size() == 2:

		var set_one : int = dice_sides_ammounts[dice_sides_ammounts.keys()[0]]
		var set_two : int = dice_sides_ammounts[dice_sides_ammounts.keys()[1]]

		#full house
		if set_one == 2 or set_one == 3:
			if set_two == 2 or set_two == 3:
				print("Full House!")

		#four on a row
		if set_one == 4 or set_two == 4:
			print("Four on a row!")

	else:
		var pair_ammount : int = 0
		var has_trio : bool = false

		for i in dice_sides_ammounts.keys().size():
			if dice_sides_ammounts[dice_sides_ammounts.keys()[i]] == 2:
				pair_ammount += 1
			if dice_sides_ammounts[dice_sides_ammounts.keys()[i]] == 3:
				has_trio = true

		if pair_ammount == 1:
			print("Pair!")
		elif pair_ammount == 2:
			print("Two Pair!")
		elif has_trio:
			print("Tree of a kind!")
		else:
			print("Nothing but singles!")

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept") == true:
		get_tree().reload_current_scene()
