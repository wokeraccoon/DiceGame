extends Control

@onready var shop_item_list: HBoxContainer = $ItemHolder
@onready var reroll_button: Button = %RerollButton
@onready var next_level_button: Button = %NextLevelButton

const SHOP_ITEM = preload("res://scenes/game/managers/shop_manager/shop_item/shop_item.tscn")

@export var item_pool : ItemPool

signal shop_exited

func _ready() -> void:
	generate_shop()
	pass

func generate_shop() -> void:
	for child : Node in shop_item_list.get_children():
		child.queue_free()

	
	for i in 3:
		var shop_item : ShopItem = SHOP_ITEM.instantiate()
		shop_item_list.add_child(shop_item)
		
		var item : Item = item_pool.item_pool.pick_random()
		item.set_description()
		shop_item.item_holder.update_item(item)
		shop_item.item_resource = item
		shop_item.item_name.text = item.item_name
		shop_item.price = item.item_value
		shop_item.item_price.text = '$' + str(item.item_value)


func _on_reroll_button_pressed() -> void:
	if ItemHelper.player_manager.money >= 5:
		ItemHelper.player_manager.update_money(-5)
		generate_shop()
	else:
		reroll_button.text = "Too poor!"
		await reroll_button.mouse_exited
		reroll_button.text = "Reroll Shop ($5)"

func _on_next_level_button_pressed() -> void:
	shop_exited.emit()
