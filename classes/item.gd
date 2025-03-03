class_name Item
extends Resource

@export var item_name : String
@export_multiline var tagline : String
@export_multiline var description : String
@export var item_texture : Texture2D = preload("res://icon.svg")

enum Owners {
	PLAYER,
	ENEMY,
	NONE
}

var item_owner : Owners = Owners.NONE

@export_range(1,999,1) var item_ammount : int = 1

var game_manager : GameManager = null

func on_item_added() -> void:
	pass

func on_item_ammount_increased() -> void:
	pass
	
func on_item_ammount_decreased() -> void:
	pass

func update_description() -> void:
	pass
