class_name PlayerDiceUI
extends Control

const DICE: PackedScene = preload("res://dice/dice.tscn")

@onready var player_dice_holder: HBoxContainer = %PlayerDiceHolder
@onready var roll_button: Button = %RollButton
@onready var attack_button: Button = %AttackButton
@onready var scoring_area: HBoxContainer = %ScoringArea
@onready var total_dice_score_label: Label = %TotalDiceScoreLabel
@onready var attack_score_label: Label = %AttackScoreLabel
@onready var rolls_left_box: MarginContainer = $BottomAreaUi/VBoxContainer/DiceArea/RollsLeftBox
@onready var rolls_left_label: Label = %RollsLeftLabel
@onready var dice_hand_label: RichTextLabel = %DiceHandLabel

@export var player_dice : Array[Dice] = []

var total_dice_score : int = 0
var rolls_left : int  = 0

signal dice_roll_finished(dice_values : Dictionary[String,int])

signal player_attacked

func _ready() -> void:
	total_dice_score = 0
	total_dice_score_label.text = str(total_dice_score)
	roll_button.hide()
	attack_button.hide()
	scoring_area.hide()
	rolls_left_box.hide()
	
	set_attack_score_label(0)
	
	show_player_dice_ui()

func show_player_dice_ui() -> void:
	
	if player_dice.is_empty():
		for i in 5:
			await get_tree().create_timer(0.25).timeout
			var dice : Dice = DICE.instantiate()
			player_dice_holder.add_child(dice)
			dice.connect("roll_complete",on_dice_roll_complete)
			player_dice.append(dice)
		
	
	await get_tree().create_timer(0.25).timeout
	dice_hand_label.text = "[shake rate=20.0 level=5 connected=1][font_size=48]Rolling...[/font_size][/shake]"
	roll_button.show()
	attack_button.show()
	scoring_area.show()
	rolls_left_box.show()
	roll_button.disabled = true
	attack_button.disabled = true
	

var dice_rolled : int = 0

func on_dice_roll_complete() -> void:
	dice_rolled += 1
	
	if dice_rolled == 5:
		dice_rolled = 0
		
		if rolls_left > 0:
			roll_button.disabled = false
		attack_button.disabled = false
		
		roll_button.grab_focus()
		
		var dice_values : Dictionary[String,int] = {}
		
		for dice in player_dice.size():
			dice_values[str("Dice",dice)] = player_dice[dice].dice_value
			
			total_dice_score += player_dice[dice].dice_value
		total_dice_score_label.text = str(total_dice_score)
		
		dice_roll_finished.emit(dice_values)
		
		

func show_dice_combo(dice_combo : DiceCalculator.DiceComboNames, combo_score) -> void:
	
	match dice_combo:
		DiceCalculator.DiceComboNames.SINGLES:
			dice_hand_label.text = str("[font_size=48]Singles (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.PAIR:
			dice_hand_label.text = str("[font_size=48]Pair (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.TWO_PAIR:
			dice_hand_label.text = str("[font_size=48]Two Pair (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.THREE_OF_A_KIND:
			dice_hand_label.text = str("[font_size=48]Three of a kind (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.FOUR_OF_A_KIND:
			dice_hand_label.text = str("[font_size=48]Four of a kind (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.FULL_HOUSE:
			dice_hand_label.text = str("[font_size=48]Full house (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.STRAIGHT:
			dice_hand_label.text = str("[font_size=48]Straight (",combo_score,")[/font_size]")
		DiceCalculator.DiceComboNames.YATCH:
			dice_hand_label.text = str("[rainbow sat=0.5][wave amp=100 freq=5][font_size=48]Yatch! (",combo_score,")[/font_size][/wave][/rainbow]")

func set_rolls_left(rolls : int) -> void:
	rolls_left = rolls
	rolls_left_label.text = str(rolls)

func set_attack_score_label(score : int) -> void:
	attack_score_label.text = str(score)

func _on_roll_button_pressed() -> void:
	roll_dice()

func roll_dice(initial_roll : bool = false) -> void:
	if !initial_roll:
		set_rolls_left(rolls_left - 1)
		
	set_attack_score_label(0)
	total_dice_score = 0
	total_dice_score_label.text = str(total_dice_score)
	
	dice_hand_label.text = "[shake rate=20.0 level=5 connected=1][font_size=48]Rolling...[/font_size][/shake]"
	
	for dice : Dice in player_dice:
		if initial_roll:
			dice.reset_dice()
		
		dice.start_roll_dice()
	
	roll_button.disabled = true
	attack_button.disabled = true

func reset_player_UI(rolls : int) -> void:
	show()
	set_rolls_left(rolls)
	roll_dice(true)

func _on_attack_button_pressed() -> void:
	hide()
	
	player_attacked.emit()
