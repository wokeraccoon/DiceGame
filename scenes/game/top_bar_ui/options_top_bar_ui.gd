class_name OptionsTopBarUI
extends MarginContainer

@onready var options_button: Button = $HBoxContainer/OptionsButton

signal options_menu_requested

func _on_options_button_pressed() -> void:
	options_menu_requested.emit()
