class_name EnemyInfoUI
extends Control

@onready var enemy_name_label: Label = %EnemyNameLabel
@onready var enemy_health_label: Label = %EnemyHealthLabel
@onready var enemy_health_bar: ProgressBar = %EnemyHealthBar
@onready var enemy_description_label: Label = %EnemyDescriptionLabel

var health_bar_value : int = 0

func set_enemy_name_description(enemy_name : String, enemy_description : String):
	enemy_name_label.text = enemy_name
	enemy_description_label.text = enemy_description

func _process(delta: float) -> void:
	if health_bar_value == enemy_health_bar.max_value:
		enemy_health_bar.value = health_bar_value
	else:
		enemy_health_bar.value = lerp(float(enemy_health_bar.value), float(health_bar_value), 25 * delta)

func set_enemy_health_info(health: int, max_health : int):
	enemy_health_bar.max_value = max_health
	health_bar_value = health
	
	enemy_health_label.text = str(health,"/",max_health)
