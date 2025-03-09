extends Item

@export var starting_health : int = 25
@export var health_per_stack : int = 5
var total_extra_health : int  = 0

func on_item_added() -> void:
	total_extra_health = (starting_health + (health_per_stack * (item_ammount - 1)))
	if !ItemHelper.on_enemy_died.is_connected(on_enemy_death):
		ItemHelper.on_enemy_died.connect(on_enemy_death)
	set_description()
		
func set_description() -> void:
	description = description.replace("{total_extra_health}",str((starting_health + (health_per_stack * (item_ammount - 1)))))
	description = description.replace("{health_per_stack}",str(health_per_stack))
	description = description.replace("{starting_health}",str(starting_health))

	
func on_enemy_death() -> void:
	ItemHelper.player_manager.update_health(total_extra_health)
	spawn_item_particles(ItemHelper.inventory_ui.health_bar)
