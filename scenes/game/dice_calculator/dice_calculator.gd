class_name DiceCalculator
extends Node

enum DiceComboNames {
	SINGLES,
	PAIR,
	TWO_PAIR,
	THREE_OF_A_KIND,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	STRAIGHT,
	YATCH
}

var dice_combos_scores : Dictionary[DiceComboNames,int] = {
	DiceComboNames.SINGLES : 1,
	DiceComboNames.PAIR : 5,
	DiceComboNames.TWO_PAIR : 10,
	DiceComboNames.THREE_OF_A_KIND : 15,
	DiceComboNames.FOUR_OF_A_KIND : 30,
	DiceComboNames.FULL_HOUSE : 25,
	DiceComboNames.STRAIGHT : 35,
	DiceComboNames.YATCH : 100
}

func count_value_occurrences_concise(my_dictionary: Dictionary, target_value) -> int:
	return my_dictionary.values().count(target_value)

func check_for_dice_combos(dice_rolled : Dictionary) -> DiceComboNames:
	var dice_sides_ammounts : Dictionary = {}

	for dice_value in 6:
		dice_value += 1
		var ocurrences = count_value_occurrences_concise(dice_rolled,dice_value)
		if ocurrences > 0:
			dice_sides_ammounts[dice_value] = ocurrences

	#yatch
	if dice_sides_ammounts.size() == 1:
		return DiceComboNames.YATCH
	
	#straights
	if dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5) and dice_sides_ammounts.has(6):
		return DiceComboNames.STRAIGHT
		
	if dice_sides_ammounts.has(1) and dice_sides_ammounts.has(2) and dice_sides_ammounts.has(3) and dice_sides_ammounts.has(4) and dice_sides_ammounts.has(5):
		return DiceComboNames.STRAIGHT

	#full house or four on a row
	if dice_sides_ammounts.size() == 2:

		var set_one : int = dice_sides_ammounts[dice_sides_ammounts.keys()[0]]
		var set_two : int = dice_sides_ammounts[dice_sides_ammounts.keys()[1]]
		
		#full house
		if set_one == 2 and set_one == 3:
			return DiceComboNames.FULL_HOUSE
		elif set_two == 2 or set_two == 3:
			return DiceComboNames.FULL_HOUSE

		#four on a row
		if set_one == 4:
			return DiceComboNames.FOUR_OF_A_KIND
		elif set_two == 4:
			return DiceComboNames.FOUR_OF_A_KIND

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
			return DiceComboNames.PAIR
		elif pair_ammount == 2:
			return DiceComboNames.TWO_PAIR
		elif has_trio:
			return DiceComboNames.THREE_OF_A_KIND
	
	return DiceComboNames.SINGLES
	
	
