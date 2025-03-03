extends Item

@export var extra_damage_perctent : int = 10

func on_item_added() -> void:
	ItemHelper.on_player_dice_ui_roll_completed.connect(_on_roll_completed)
	description = "Increases attack by "+ str(extra_damage_perctent) + "%"
	description += "\n[+"+str(extra_damage_perctent)+"% per stack, currently " + str(extra_damage_perctent * item_ammount) + "%]"


func _on_roll_completed() -> void:
	var current_player_score : int = ItemHelper.battle_manager.player_attack_score
	current_player_score += roundi(current_player_score * ((10.0 * item_ammount) / 100.0))
	print(current_player_score)
	ItemHelper.battle_manager.player_attack_score = current_player_score
	ItemHelper.player_dice_ui.attack_score_label.text = str(ItemHelper.battle_manager.player_attack_score)
	ItemHelper.battle_manager.item_particles.global_position = ItemHelper.battle_manager.player_dice_ui.attack_score_label.global_position
	ItemHelper.battle_manager.item_particles.restart()
