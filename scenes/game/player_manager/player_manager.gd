class_name PlayerManager
extends Node

var max_health : int = 500
var health : int = 500

var money : int  = 3

var rolls : int = 3

@export var inventory : Array[Item] = []

@export var player_class : PlayerClass
