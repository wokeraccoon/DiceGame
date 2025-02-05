class_name Main
extends Node

const MAIN_MENU_UI = preload("res://scenes/main_menu/main_menu_ui.tscn")
const GAME = preload("res://scenes/game/game_manager.tscn")
const OPTIONS_MENU_UI = preload("res://scenes/options_menu/options_menu_ui.tscn")
@onready var main_layer: CanvasLayer = %MainLayer
@onready var pause_layer: CanvasLayer = %PauseLayer

var game : GameManager

func _ready() -> void:
	var main_menu : MainMenuUI = MAIN_MENU_UI.instantiate()
	main_layer.add_child(main_menu)
	main_menu.new_run_requested.connect(_new_run)

func _new_run() -> void:
	if game != null:
		_unpause_game()
		game.queue_free()
		
	for child in main_layer.get_children():
		child.queue_free()
	
	game = GAME.instantiate()
	main_layer.add_child(game)
	
	game.top_bar_ui.options_menu_requested.connect(_pause_game)

func _pause_game() -> void:
	var options_menu : OptionsMenuUI = OPTIONS_MENU_UI.instantiate()
	pause_layer.add_child(options_menu)
	
	options_menu.back_to_game_requested.connect(_unpause_game)
	options_menu.new_run_requested.connect(_new_run)
	options_menu.main_menu_requested.connect(_restart_game)
	
	process_mode = Node.PROCESS_MODE_DISABLED

func _unpause_game() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	for child : Node in pause_layer.get_children():
		child.queue_free()
	
func _restart_game() -> void:
	get_tree().reload_current_scene()
