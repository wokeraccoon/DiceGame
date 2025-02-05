class_name MainMenuUI
extends Control

@onready var quit_button: Button = %QuitButton

@onready var new_game_button: Button = %NewGameButton

signal new_run_requested

func _ready() -> void:
	if OS.has_feature("android"):
		quit_button.hide()
	
	new_game_button.grab_focus()

func _on_new_game_button_pressed() -> void:
	new_run_requested.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
