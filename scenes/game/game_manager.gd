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

var is_player_turn : bool = true

var player_max_health : int = 300
var player_current_health : int = 300
var starter_rolls : int = 3
var player_rolls : int = 3

var enemy_max_health : int = 100
var enemy_current_health : int = 100


var dice_hand_score : int = 0
var dice_hand_combo : String = ""

signal restart_run

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


@onready var player_health_bar: ProgressBar = %PlayerHealthBar
@onready var player_health_text: Label = %PlayerHealthText

@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_health_text: Label = %EnemyHealthText

@onready var player_dice_ui: MarginContainer = %PlayerDiceUI
@onready var enemy_dice_ui: MarginContainer = %EnemyDiceUI

@export var player_dice : Array[Dice] = []
@export var enemy_dice : Array[Dice] = []

@onready var player_rolls_ammount: Label = %PlayerRollsAmmount
@onready var roll_dice_button: Button = %RollDiceButton
@onready var send_attack_button: Button = %SendAttackButton

@onready var player_dice_combo: Label = %PlayerDiceCombo
@onready var player_dice_score: Label = %PlayerDiceScore
@onready var enemy_damage_label: Label = %EnemyDamageLabel
@onready var enemy_dice_combo: Label = %EnemyDiceCombo
@onready var enemy_dice_score: Label = %EnemyDiceScore

@onready var fight_ui_animation_player: AnimationPlayer = %FightUIAnimationPlayer

var is_dice_rolling : bool = false

func _ready() -> void:
	for dice in player_dice:
		dice.roll_finished.connect(_on_player_roll_finished)
	
	for dice in enemy_dice:
		dice.disable_dice()
		dice.roll_finished.connect(_on_enemy_roll_finished)
		
	player_dice_ui.visible = true
	enemy_dice_ui.visible = false

func _process(delta: float) -> void:
	
	player_health_bar.max_value = player_max_health
	player_health_bar.value = player_current_health
	player_health_text.text = str(player_current_health,"/",player_max_health)
	
	enemy_health_bar.max_value = enemy_max_health
	enemy_health_bar.value = enemy_current_health
	enemy_health_text.text = str(enemy_current_health,"/",enemy_max_health)
	
	
	if player_rolls == 0 or is_dice_rolling == true:
		roll_dice_button.disabled = true
	else:
		roll_dice_button.disabled = false
	
	if is_dice_rolling == true or player_rolls == starter_rolls:
		send_attack_button.disabled = true
	else:
		send_attack_button.disabled = false
	
	player_dice_combo.text = dice_hand_combo
	player_dice_score.text = str(dice_hand_score)
	player_rolls_ammount.text = str(player_rolls)
	
	enemy_dice_combo.text = dice_hand_combo
	enemy_dice_score.text = str(dice_hand_score)


func _on_roll_dice_button_pressed() -> void:
	dice_rolled = 0
	for dice in player_dice:
		dice.roll_dice()
		
		if player_rolls == starter_rolls:
			dice.reset_dice()
	
	player_rolls -= 1
	is_dice_rolling = true

func _on_send_attack_button_pressed() -> void:
	dice_rolled = 0
	enemy_damage_label.text = str(dice_hand_score, "ATTACK POINTS")
	enemy_current_health -= dice_hand_score
	fight_ui_animation_player.play("HIT_TO_ENEMY")
	is_player_turn = false

var dice_rolled : int = 0

func _on_player_roll_finished() -> void:
	dice_rolled += 1
	
	var dice_data : Dictionary = {}
	
	if dice_rolled == 5:
		is_dice_rolling = false
		
		for dice in player_dice:
			dice_data[dice.name] = dice.current_number
		
		check_for_dice_combos(dice_data)

func _on_enemy_roll_finished() -> void:
	dice_rolled += 1
	
	var dice_data : Dictionary = {}
	
	if dice_rolled == 5:
		is_dice_rolling = false
		
		for dice in enemy_dice:
			dice_data[dice.name] = dice.current_number
		
		check_for_dice_combos(dice_data)
		
		enemy_damage_label.text = str(dice_hand_score, " DAMAGE POINTS")
		fight_ui_animation_player.play("HIT_TO_PLAYER")
		player_current_health -= dice_hand_score

func enemy_attack() -> void:
	
	if enemy_current_health <= 0:
		win_screen.visible = true
	else:
		dice_hand_score = 0
		dice_hand_combo = ""
		player_rolls = starter_rolls
		for dice in enemy_dice:
			dice.roll_dice()
	
	dice_rolled = 0

func reset_player_ui() -> void:
	if player_current_health <= 0:
		defeat_screen.visible = true
	else:
		dice_hand_score = 0
		dice_hand_combo = ""
		player_rolls = starter_rolls
		for dice in player_dice:
			dice.reset_dice()

	
	
@onready var defeat_screen: ColorRect = %DefeatScreen
@onready var win_screen: ColorRect = %WinScreen


func _on_new_game_button_pressed() -> void:
	restart_run.emit()
