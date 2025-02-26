class_name EnemyDiceUI
extends Control

@onready var enemy_dice_holder: HBoxContainer = %EnemyDiceHolder
@onready var enemy_attack_score_label: RichTextLabel = %EnemyAttackScoreLabel

const DICE: PackedScene = preload("res://dice/dice.tscn")

var enemy_dice : Array[Dice] = []

var max_dice_ammount : int = 1
var dice_rolled : int = 0

signal dice_roll_finished(dice_values : Dictionary[String,int])

func set_dice_ammount(dice_ammount : int) -> void:
	max_dice_ammount = dice_ammount

func roll_dice() -> void:
	
	if enemy_dice.is_empty():
		for i in max_dice_ammount:
			var dice : Dice = DICE.instantiate()
			enemy_dice_holder.add_child(dice)
			dice.connect("roll_complete",on_dice_roll_complete)
			enemy_dice.append(dice)
			dice.dice_owner = Dice.DiceOwners.ENEMY
			dice.restart_dice()
	else:
		for dice : Dice in enemy_dice:
			dice.restart_dice()
	
	enemy_attack_score_label.text = "[shake rate=25.0 level=5 connected=0][font_size=64]Enemy is rolling...[/font_size][/shake]"


func on_dice_roll_complete() -> void:
	dice_rolled += 1
	
	if dice_rolled == max_dice_ammount:
		dice_rolled = 0
		
		var dice_values : Dictionary[String,int] = {}
		
		for dice in enemy_dice.size():
			dice_values[str("Dice",dice)] = enemy_dice[dice].dice_value
		
		dice_roll_finished.emit(dice_values)

func show_enemy_attack_score(dice_combo : DiceCalculator.DiceComboNames, attack_score : int) -> void:
	
	match dice_combo:
		DiceCalculator.DiceComboNames.SINGLES:
			enemy_attack_score_label.text = str("[font_size=64]Singles - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.PAIR:
			enemy_attack_score_label.text = str("[font_size=64]Pair  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.TWO_PAIR:
			enemy_attack_score_label.text = str("[font_size=64]Two Pair  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.THREE_OF_A_KIND:
			enemy_attack_score_label.text = str("[font_size=64]Three of a kind  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.FOUR_OF_A_KIND:
			enemy_attack_score_label.text = str("[font_size=64]Four of a kind  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.FULL_HOUSE:
			enemy_attack_score_label.text = str("[font_size=64]Full house  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.STRAIGHT:
			enemy_attack_score_label.text = str("[font_size=64]Straight  - ",attack_score," pts[/font_size]")
		DiceCalculator.DiceComboNames.YATCH:
			enemy_attack_score_label.text = str("[font_size=64]Yatch  - ",attack_score," pts[/font_size]")
