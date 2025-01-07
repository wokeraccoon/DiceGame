class_name OptionsMenuUI
extends Control

@onready var back_to_game_button: Button = %BackToGameButton

signal main_menu_requested
signal restart_run_requested

func _on_back_to_game_button_pressed() -> void:
	visible = false

func _on_main_menu_button_pressed() -> void:
	main_menu_requested.emit()

func _on_restart_run_button_pressed() -> void:
	restart_run_requested.emit()
