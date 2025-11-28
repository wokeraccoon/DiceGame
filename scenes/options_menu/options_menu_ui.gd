class_name OptionsMenuUI
extends Control

@onready var back_to_game_button: Button = %BackToGameButton

signal main_menu_requested
signal new_run_requested

signal back_to_game_requested

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		back_to_game_requested.emit()

func _on_back_to_game_button_pressed() -> void:
	back_to_game_requested.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu_requested.emit()

func _on_new_run_button_pressed() -> void:
	new_run_requested.emit()
