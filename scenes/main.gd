class_name Main
extends Node

const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")
const GAME = preload("res://scenes/game/game_manager.tscn")

@onready var main_layer: CanvasLayer = %MainLayer

var game : GameManager

func _ready() -> void:
	var main_menu : MainMenu = MAIN_MENU.instantiate()
	main_layer.add_child(main_menu)
	main_menu.new_game_started.connect(_start_new_game)
	
	if OS.has_feature("android"):
		get_tree().root.content_scale_factor = 1

	else:
		get_tree().root.content_scale_factor = 0.8

func _start_new_game() -> void:
	for child in main_layer.get_children():
		child.queue_free()
	
	game = GAME.instantiate()
	main_layer.add_child(game)
	game.restart_run.connect(_restart_game)

func _restart_game() -> void:
	game.queue_free()
	_start_new_game()
