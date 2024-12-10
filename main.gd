extends Node2D

@onready var scoreboard: Label = $Scoreboard
@onready var roll_button: Button = $RollButton
@onready var round_stats: Label = $RoundStats
@onready var game_result: Label = $GameResult

@export var dices : Array[Dice]

var current_round : int = 1
var score_to_win : int = 10
var rolls_left : int = 3
var total_score : int = 0
var reset_game : bool = true
var reset_dice : bool = true

var unlocked_combos : Dictionary = {
	"singles" : true,
	"pair" : false,
	"two pair" : false,
	"tree-of-a-kind" : false,
	"four-of-a-kind" : false,
	"full-house" : false,
	"little straight" : false,
	"big straight" : false,
	"yatch" : false
}


func _ready() -> void:
	scoreboard.text = ""
	for dice in dices:
		dice.dice_rolled.connect(_on_dice_rolled)
		#_on_roll_button_pressed()

func _process(delta: float) -> void:
	round_stats.text = str(
		"Round ",current_round, "\n",
		"Score at least ", score_to_win, "\n",
		rolls_left," rolls left", "\n"
	)
	

func _on_roll_button_pressed() -> void:
	if reset_game:
		current_round = 1
		rolls_left = 3
		score_to_win = 10
		reset_game = false
	
	game_result.visible = false
	roll_button.disabled = true
	
	dice_rolled = 0
	dice_values.clear()
	
	for dice in dices:
		if reset_dice:
			dice.is_locked = false
			dice._on_mouse_detector_mouse_exited()
		
		dice.roll()
	scoreboard.text = "rolling..."

var dice_values : Dictionary = {
}

var dice_rolled : int = 0

func _on_dice_rolled(value : int) -> void:
	dice_rolled += 1
	
	if dice_values.has(value):
		dice_values[value] += 1
	else:
		dice_values[value] = 1
	
	if dice_rolled == dices.size():
		scoreboard.text = ""
		roll_button.disabled = false
		total_score = 0
		
		#singles
		if dice_values.has(1):
			scoreboard.text += str("Ones (1x",dice_values[1],") +",1 * dice_values[1],"\n")
			total_score += 1 * dice_values[1]
		if dice_values.has(2):
			scoreboard.text += str("Twos (2x",dice_values[2],") +",2 * dice_values[2],"\n")
			total_score += 2 * dice_values[2]
		if dice_values.has(3):
			scoreboard.text += str("Threes (3x",dice_values[3],") +",3 * dice_values[3],"\n")
			total_score += 3 * dice_values[3]
		if dice_values.has(4):
			scoreboard.text += str("Fours (4x",dice_values[4],") +",4 * dice_values[4],"\n")
			total_score += 4 * dice_values[4]
		if dice_values.has(5):
			scoreboard.text += str("Fives (5x",dice_values[5],") +",5 * dice_values[5],"\n")
			total_score += 5 * dice_values[5]
		if dice_values.has(6):
			scoreboard.text += str("Sixes (6x",dice_values[6],") +",6 * dice_values[6],"\n")
			total_score += 6 * dice_values[6]
		
		#full house or four of a kind
		if dice_values.size() == 2:
			
			var set_one : int = dice_values[dice_values.keys()[0]]
			var set_two : int = dice_values[dice_values.keys()[1]]
			
			#full house
			if set_one == 2 or set_one == 3:
				if set_two == 2 or set_two == 3:
					var full_house : int = 0
					full_house += dice_values.keys()[0] * set_one
					full_house += dice_values.keys()[1] * set_two
					
					total_score += full_house
					
					scoreboard.text += str("Full House +",full_house,"\n")
			
			#four on a row
			var four_on_a_row : int = 0
			if set_one == 4:
				four_on_a_row += dice_values.keys()[0] * set_one
			elif set_two == 4:
				four_on_a_row += dice_values.keys()[1] * set_two
			
			if four_on_a_row > 0:
				total_score += four_on_a_row
				scoreboard.text += str("Four on a row +",four_on_a_row,"\n")
		
		#little straight
		if dice_values.has(1) and dice_values.has(2) and dice_values.has(3) and dice_values.has(4) and dice_values.has(5):
			scoreboard.text += str("Little Straight +30\n")
			total_score += 30
		
		#large straight
		if dice_values.has(2) and dice_values.has(3) and dice_values.has(4) and dice_values.has(5) and dice_values.has(6) :
			scoreboard.text += str("Large Straight +30\n")
			total_score += 30
		
		#yacht
		if dice_values.size() == 1:
			scoreboard.text += str("Yatch! +50","\n")
			total_score += 50
		
		scoreboard.text += str("TOTAL: ", total_score)
		
		reset_dice = false
		rolls_left -= 1
		
		if rolls_left == 0:
			if total_score >= score_to_win:
				game_result.show()
				game_result.text = "ROUND WON!"
				current_round += 1
				rolls_left = 3
				score_to_win += 10
				reset_game = false
			else:
				game_result.show()
				game_result.text = "Round lost..."
				reset_game = true
			
			reset_dice = true
