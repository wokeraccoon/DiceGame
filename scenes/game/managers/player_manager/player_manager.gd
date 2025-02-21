class_name PlayerManager
extends Node

var max_health : int = 500

var health : int = 100

var money : int  = 3

var rolls : int = 4

@export var inventory : Array[Item] = []
@export var player_class : PlayerClass

@onready var top_bar_ui: TopBarUI = %TopBarUI

signal player_died

func _ready() -> void:
	if player_class:
		max_health = player_class.base_health
		rolls += player_class.additional_rolls
		money += player_class.additional_money
	
	health = max_health
	
	await top_bar_ui.ready
	top_bar_ui.update_health(health,max_health)

enum PlayerStatuses {
	ALIVE,
	DEAD
}

func update_health(health_change : int = 0, max_health_change : int = 0) -> void:
	health += health_change
	max_health += max_health_change
	
	if health > max_health:
		health = max_health
	
	if health_change > 0 or max_health_change > 0:
		top_bar_ui.update_health(health,max_health,TopBarUI.HealthUpdates.HEAL)
	elif health_change < 0 or max_health_change < 0:
		top_bar_ui.update_health(health,max_health,TopBarUI.HealthUpdates.DAMAGE)
	
	if health <= 0:
		player_died.emit()
