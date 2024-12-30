class_name ItemButton
extends MarginContainer

@onready var item_name_label: Label = %ItemNameLabel
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var item_price_label: Label = %ItemPriceLabel
@onready var item_icon_texture_rect: TextureRect = %ItemIconTextureRect
@onready var button: Button = %Button

var attached_item : Item

signal item_selected(item : Item)

func _on_button_pressed() -> void:
	item_selected.emit(attached_item)
