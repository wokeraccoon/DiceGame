class_name ItemHolder
extends MarginContainer

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture

func _ready() -> void:
	updated_item()

func updated_item(item : Item = null) -> void:
	if item == null:
		item_texture.hide()
	else:
		item_texture.texture = item.item_texture
