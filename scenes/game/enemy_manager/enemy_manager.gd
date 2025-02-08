class_name EnemyManager
extends Node

var max_health : int = 100

var health : int = 100

var dice_ammount : int = 2

@export var inventory : Array[Item] = []
@export var enemy_resource : Enemy


func _ready() -> void:
	max_health = enemy_resource.base_health
	health = max_health
