class_name MainMenu
extends Control

signal new_game_started

func _on_new_game_button_pressed() -> void:
	new_game_started.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
