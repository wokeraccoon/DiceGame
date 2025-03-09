extends Item

@export var extra_damage_percent : int = 10

func on_item_added() -> void:
	if !ItemHelper.on_player_dice_ui_roll_completed.is_connected(_on_roll_completed):
		ItemHelper.on_player_dice_ui_roll_completed.connect(_on_roll_completed)
	set_description()
	
func set_description() -> void:
	description = description.replace("{current_percent}",str(extra_damage_percent * item_ammount))
	description = description.replace("{percent}",str(extra_damage_percent * item_ammount))


func _on_roll_completed() -> void:
	var current_player_score : int = ItemHelper.battle_manager.player_attack_score
	current_player_score += roundi(current_player_score * ((extra_damage_percent * item_ammount) / 100.0))
	ItemHelper.battle_manager.player_attack_score = current_player_score
	ItemHelper.player_dice_ui.attack_score_label.text = str(ItemHelper.battle_manager.player_attack_score)
	
	spawn_item_particles(ItemHelper.player_dice_ui.attack_score_label)
