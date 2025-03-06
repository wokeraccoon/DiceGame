extends Control

@onready var shop_item_list: HBoxContainer = $ItemHolder

const SHOP_ITEM = preload("res://scenes/game/managers/shop_manager/shop_item/shop_item.tscn")

@export var item_pool : ItemPool

func _ready() -> void:
	generate_shop()
	pass

func generate_shop() -> void:
	for child : Node in shop_item_list.get_children():
		child.queue_free()
	
	var temp_item_list : ItemPool = item_pool.duplicate()
	
	for i in 3:
		var shop_item : ShopItem = SHOP_ITEM.instantiate()
		shop_item_list.add_child(shop_item)
		
		var item : Item = temp_item_list.item_pool.pick_random()
		shop_item.item_holder.update_item(item,false)
