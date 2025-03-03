class_name PlayerManager
extends Node

var max_health : int = 500

var health : int = 100

var money : int  = 3

var rolls : int = 4

@export var player_items : Array[Item] = []
@export var player_class : PlayerClass

@onready var inventory_ui: InventoryUI = %InventoryUI

signal player_died

func _ready() -> void:
	if player_class:
		max_health = player_class.base_health
		rolls += player_class.additional_rolls
		money += player_class.additional_money
	
	health = max_health
	
	for item : Item in player_items:
		item.game_manager = get_parent()
		item.item_owner = Item.Owners.PLAYER
		item.item_ammount = 99999
		item.on_item_added()
		
	
	await inventory_ui.ready
	inventory_ui.update_player_health(health,max_health)
	inventory_ui.update_item_grid(player_items)

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
		inventory_ui.update_player_health(health,max_health)
	elif health_change < 0 or max_health_change < 0:
		inventory_ui.update_player_health(health,max_health)
	
	if health <= 0:
		player_died.emit()
