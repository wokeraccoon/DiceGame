class_name ItemHolder
extends MarginContainer

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture
@onready var quantity_label: Label = $QuantityLabel
@onready var item_description: ItemDescription = %ItemDescription


func update_item(item : Item = null, show_ammount : bool = true) -> void:
	if item == null:
		item_texture.hide()
	else:
		item_texture.texture = null
		item_texture.texture = item.item_texture
		quantity_label.text = "x" + str(item.item_ammount)
		quantity_label.visible = show_ammount
		item_description.set_item_info(item)
	

func _process(delta: float) -> void:
	
	if item_description.visible:
		var mouse_pos : Vector2 = get_global_mouse_position()
		item_description.global_position = mouse_pos


func _on_mouse_entered() -> void:
	item_description.show()

func _on_mouse_exited() -> void:
	item_description.hide()
