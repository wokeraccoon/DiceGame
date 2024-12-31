class_name Main
extends Node

const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")
const GAME = preload("res://scenes/game/game.tscn")

@onready var main_layer: CanvasLayer = %MainLayer

var game : Game

func _ready() -> void:
	var main_menu : MainMenu = MAIN_MENU.instantiate()
	main_layer.add_child(main_menu)
	main_menu.new_game_started.connect(_start_new_game)

func _start_new_game() -> void:
	for child in main_layer.get_children():
		child.queue_free()
	
	game = GAME.instantiate()
	main_layer.add_child(game)
