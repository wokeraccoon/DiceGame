class_name ItemHolder
extends MarginContainer

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture
@onready var item_description: ItemDescription = %ItemDescription


func update_item(item : Item = null) -> void:
	if item == null:
		item_texture.hide()
	else:
		item_texture.texture = null
		item_texture.texture = item.item_texture
		item_description.set_item_info(item)
	

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	
	if item_description.visible:
		item_description.global_position = mouse_pos.clamp(
			Vector2.ZERO,
			(get_viewport_rect().size - item_description.size)
		)


func _on_mouse_entered() -> void:
	item_description.show()

func _on_mouse_exited() -> void:
	item_description.hide()
