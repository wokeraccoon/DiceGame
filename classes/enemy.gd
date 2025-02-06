class_name Enemy
extends Resource

@export var name : String = "Enemy"
@export var short_description : String = "Test"
@export_range(1,5,1) var dice_ammount : int = 1
@export var enemy_sprite : Texture2D = preload("res://icon.svg")
@export var default_items : Array[Item] = []
@export var base_health : int = 300
