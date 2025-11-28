class_name ItemDescription
extends MarginContainer

@onready var item_texture: TextureRect = %ItemTexture
@onready var item_name: Label = %ItemName
@onready var item_tag_line: Label = %ItemTagLine
@onready var item_description: Label = %ItemDescription

func set_item_info(item : Item) -> void:
	item_texture.texture = item.item_texture
	item_name.text = item.item_name
	item_tag_line.text = item.tagline
	item_description.text = item.description
