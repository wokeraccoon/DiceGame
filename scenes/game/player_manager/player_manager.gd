class_name PlayerManager
extends Node

var max_health : int = 500
var health : int = 500

var money : int  = 3

var rolls : int = 3

@export var inventory : Array[Item] = []

@export var player_class : PlayerClass

func _ready() -> void:
	if player_class:
		max_health = player_class.base_health
		health = max_health
		
		rolls += player_class.additional_rolls
		
		money += player_class.additional_money
