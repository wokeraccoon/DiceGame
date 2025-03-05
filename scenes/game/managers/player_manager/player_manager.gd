class_name PlayerManager
extends Node

var max_health : int = 500

var health : int = 100

var money : int  = 3

var rolls : int = 4

@export var starting_items : Array[Item] = []

var player_items : Array[Item] = []
@export var player_class : PlayerClass

@onready var inventory_ui: InventoryUI = %InventoryUI

signal player_died

func _ready() -> void:
	if player_class:
		max_health = player_class.base_health
		rolls += player_class.additional_rolls
		money += player_class.additional_money
	
	health = max_health
	
	await inventory_ui.ready
	inventory_ui.update_player_health(health,max_health)
	
	for item : Item in starting_items:
		add_item(item)

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

func add_item(item : Item) -> void:
	if !player_items.has(item):
		player_items.append(item)
		item.item_owner = Item.Owners.PLAYER
	else:
		var existing_item : Item = player_items[player_items.bsearch(item)]
		
		existing_item.item_ammount += 1
	
	item.on_item_added()
	inventory_ui.update_item_grid(player_items)
