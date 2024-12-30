class_name ItemPicker
extends Control

const ITEM_BUTTON = preload("res://scenes/game/ui/item_picker/item_button.tscn")

@onready var item_holder: HBoxContainer = %ItemHolder

signal item_selected(item : Item)

func add_button(item : Item, price : int) -> void:
	var item_button : ItemButton = ITEM_BUTTON.instantiate()
	item_holder.add_child(item_button)
	item_button.item_name_label.text = item.item_name
	item_button.item_description_label.text = item.item_description
	item_button.item_icon_texture_rect.texture = item.item_texture
	item_button.attached_item = item
	
	if item is Weapon:
		var weapon : Weapon = item
		item_button.item_description_label.text += str(
			"\n\n",weapon.base_damage," Base Damage"
		)
	
	if price > 0 or price < 0:
		item_button.item_price_label.text = str('$ ',price)
	else:
		item_button.item_price_label.text = "FREE"
	
	item_button.item_selected.connect(on_button_pressed)

func on_button_pressed(item : Item) -> void:
	queue_free()
	item_selected.emit(item)
