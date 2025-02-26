class_name EnemyManager
extends Node

var max_health : int = 1000

var health : int = 1000

var dice_ammount : int = 5

@export var inventory : Array[Item] = []
@export var enemy_resource : Enemy

signal enemy_died
 
func update_health(health_change : int = 0, max_health_change : int = 0) -> void:
	health += health_change
	max_health += max_health_change
	
	if health > max_health:
		health = max_health

	if health <= 0:
		enemy_died.emit()
