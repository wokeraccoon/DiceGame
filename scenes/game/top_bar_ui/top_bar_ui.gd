class_name TopBarUI
extends MarginContainer

@onready var options_button: Button = %OptionsButton
@onready var player_health_label: Label = %PlayerHealthLabel
@onready var player_money_label: Label = %PlayerMoneyLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal options_menu_requested

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		options_menu_requested.emit()

func _on_options_button_pressed() -> void:
	options_menu_requested.emit()

enum HealthUpdates {
	HEAL,
	DAMAGE,
	NONE
}

func update_health(health : int, max_health : int, update_type : HealthUpdates = HealthUpdates.NONE) -> void:
	player_health_label.text = str(health) + "/" + str(max_health)
	animation_player.stop()
	
	match update_type:
		HealthUpdates.HEAL:
			animation_player.play("HEALTH_HEALING")
		HealthUpdates.DAMAGE:
			animation_player.play("HEALTH_DAMAGE")
		HealthUpdates.NONE:
			pass
