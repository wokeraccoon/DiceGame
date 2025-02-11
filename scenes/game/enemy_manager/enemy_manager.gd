class_name EnemyManager
extends Node

var max_health : int = 100

var health : int = 100

var dice_ammount : int = 2

@export var inventory : Array[Item] = []
@export var enemy_resource : Enemy


func _ready() -> void:
	dice_ammount = randi_range(2,5)
	max_health = randi_range(5,10) * 100
	health = max_health
