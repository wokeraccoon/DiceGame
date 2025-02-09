class_name MainMenuUI
extends Control

@onready var quit_button: Button = %QuitButton
@onready var version_label: Label = %VersionLabel

@onready var new_game_button: Button = %NewGameButton

signal new_run_requested

func _ready() -> void:
	if OS.has_feature("mobile") or OS.has_feature("web"):
		quit_button.hide()
	elif OS.has_feature("pc"):
		quit_button.show()
	
	version_label.text = ProjectSettings.get_setting("application/config/version")
	
	new_game_button.grab_focus()

func _on_new_game_button_pressed() -> void:
	new_run_requested.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
