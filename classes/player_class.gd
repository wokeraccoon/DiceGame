class_name PlayerClass
extends Resource

@export var player_class_name : String = ""
@export var description : String = ""
@export var sprite : Texture2D = preload("res://icon.svg")
@export var base_health : int = 100
@export var additional_rolls : int = 0
@export var additional_money : int = 0
@export var starter_items : Array[Item]
