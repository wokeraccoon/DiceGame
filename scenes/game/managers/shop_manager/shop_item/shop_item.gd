class_name ShopItem
extends MarginContainer

@onready var item_holder: ItemHolder = %ItemHolder
@onready var item_name: Label = %ItemName
@onready var item_price: Button = %ItemPrice

var price : int = 0
var item_resource : Item = null

func _on_item_price_mouse_entered() -> void:
	if !item_price.disabled:
		item_price.text = "Buy?"

func _on_item_price_mouse_exited() -> void:
	if !item_price.disabled:
		item_price.text = "$" + str(price)


func _on_item_price_pressed() -> void:
	if ItemHelper.player_manager != null:
		if ItemHelper.player_manager.money >= price:
			item_price.disabled = true
			item_price.text = "Purchased!"
			ItemHelper.player_manager.update_money(-price)
			ItemHelper.player_manager.add_item(item_resource)
		else:
			item_price.text = "Too poor!"
