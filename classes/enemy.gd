class_name Enemy
extends Resource

@export var enemy_name : String = "Enemy"
@export_multiline var short_description : String = "Test"
@export var enemy_sprite : Texture2D = preload("res://icon.svg")
@export var default_items : Array[Item] = []
@export var base_health : int = 300
@export_range(1,5) var max_dice_ammount : int = 5

enum EnemyTypes {
	EARLY_LEVEL,
	MID_LEVEL,
	HIGH_LEVEL,
	BOSS
}

@export var enemy_type : EnemyTypes = EnemyTypes.EARLY_LEVEL
