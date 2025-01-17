class_name DiceCalculator
extends Node

enum DiceHandNames {
	SINGLES,
	PAIR,
	TWO_PAIR,
	THREE_OF_A_KIND,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	STRAIGHT,
	YATCH
}

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

func count_value_occurrences_concise(my_dictionary: Dictionary, target_value) -> int:
	return my_dictionary.values().count(target_value)

func check_for_dice_combos(dice_rolled : Dictionary) -> DiceHandNames:
	var dice_sides_ammounts : Dictionary = {}

	for dice_value in 6:
		dice_value += 1
		var ocurrences = count_value_occurrences_concise(dice_rolled,dice_value)
		if ocurrences > 0:
			dice_sides_ammounts[dice_value] = ocurrences

	#yatch
	if dice_sides_ammounts.size() == 1:
		return DiceHandNames.YATCH
	
	#straights
	if dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5) and dice_sides_ammounts.has(6):
		return DiceHandNames.STRAIGHT
		
	if dice_sides_ammounts.has(1) and dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5):
		return DiceHandNames.STRAIGHT

	#full house or four on a row
	if dice_sides_ammounts.size() == 2:

		var set_one : int = dice_sides_ammounts[dice_sides_ammounts.keys()[0]]
		var set_two : int = dice_sides_ammounts[dice_sides_ammounts.keys()[1]]
		
		#full house
		if set_one == 2 and set_one == 3:
			return DiceHandNames.FULL_HOUSE
		elif set_two == 2 or set_two == 3:
			return DiceHandNames.FULL_HOUSE

		#four on a row
		if set_one == 4:
			return DiceHandNames.FOUR_OF_A_KIND
		elif set_two == 4:
			return DiceHandNames.FOUR_OF_A_KIND

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
			return DiceHandNames.PAIR
		elif pair_ammount == 2:
			return DiceHandNames.TWO_PAIR
		elif has_trio:
			return DiceHandNames.THREE_OF_A_KIND
	
	return DiceHandNames.SINGLES
	
	
