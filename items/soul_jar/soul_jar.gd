extends Item

@export var extra_health : int = 25
@export var health_per_stack : int = 5

func on_item_added() -> void:
	if !ItemHelper.on_enemy_died.is_connected(on_enemy_death):
		ItemHelper.on_enemy_died.connect(on_enemy_death)
	description = str("After killing enemy, gain +",extra_health + (health_per_stack * (item_ammount - 1))," health")
	description += str("\n[Starts at +", extra_health," health, Gains 5+ per stack")

func on_enemy_death() -> void:
	ItemHelper.player_manager.update_health(extra_health + (health_per_stack * (item_ammount - 1)))
	spawn_item_particles(ItemHelper.inventory_ui.health_bar)
