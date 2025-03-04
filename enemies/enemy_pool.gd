class_name EnemyPool
extends Resource

@export var enemy_pool : Array[Enemy] = []

func request_enemy_from_pool(enemy_type : Enemy.EnemyTypes) -> Enemy:
	
	return enemy_pool.pick_random()
