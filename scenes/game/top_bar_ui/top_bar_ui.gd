class_name TopBarUI
extends MarginContainer

@onready var options_button: Button = %OptionsButton
@onready var player_health_label: Label = %PlayerHealthLabel
@onready var player_money_label: Label = %PlayerMoneyLabel

signal options_menu_requested

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		options_menu_requested.emit()

func _on_options_button_pressed() -> void:
	options_menu_requested.emit()

func update_health(health : int, max_health : int):
	player_health_label.text = str(health,"/",max_health)
	
func update_money(money : int):
	player_money_label.text = str("$",money)
