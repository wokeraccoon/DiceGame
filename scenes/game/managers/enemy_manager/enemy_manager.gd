class_name EnemyManager
extends Node

@export var inventory : Array[Item] = []
@export var enemy_resource : Enemy

var enemy_name : String
var enemy_description : String
var max_health : int = 1000
var health : int = 1000
var dice_ammount : int = 5

var enemy_texture : Texture2D

signal enemy_died

func preparate_new_enemy(new_enemy : Enemy) -> void:
	enemy_resource = new_enemy
	enemy_name = enemy_resource.enemy_name
	enemy_description = enemy_resource.short_description
	max_health = enemy_resource.base_health
	health = max_health
	dice_ammount = enemy_resource.max_dice_ammount
	enemy_texture = enemy_resource.enemy_sprite
	pass

func update_health(health_change : int = 0, max_health_change : int = 0) -> void:
	health += health_change
	max_health += max_health_change
	
	if health > max_health:
		health = max_health

	if health <= 0:
		enemy_died.emit()
