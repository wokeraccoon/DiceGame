@tool
class_name MapOption
extends Button

@onready var option_icon: TextureRect = %OptionIcon
@onready var selected_icon: TextureRect = %SelectedIcon

signal option_selected(type : Types)

enum Types {
	#START,
	BOSS,
	FIGHT,
	SHOP,
	CHEST,
	RANDOM
}

var button_type : Types = Types.FIGHT

func set_type(type : Types) -> void:
	
	var option_icon_texture : AtlasTexture = option_icon.texture
	
	button_type = type
	
	match type:
		#Types.START:
			#custom_minimum_size = Vector2(128,128) * 2
			#option_icon.custom_minimum_size *= 2
			#option_icon_texture.region.position = Vector2.ZERO
		Types.FIGHT:
			option_icon_texture.region.position.x = 1 * 32
		Types.SHOP:
			option_icon_texture.region.position.x = 2 * 32
		Types.CHEST:
			option_icon_texture.region.position.x = 3 * 32
		Types.RANDOM:
			option_icon_texture.region.position.x = 4 * 32
		Types.BOSS:
			custom_minimum_size = Vector2(128,128) * 2
			option_icon_texture.region.position.x = 5 * 32
			option_icon.custom_minimum_size *= 2
		

func _process(delta: float) -> void:
	
	if is_hovered() and !disabled:
		option_icon.self_modulate = Color("#ffffff")
	elif disabled:
		option_icon.self_modulate = Color("#966c6c")
		selected_icon.self_modulate = Color("#6e2727")
	elif button_pressed == true:
		option_icon.self_modulate = Color("#e83b3b")
		selected_icon.self_modulate = Color("#b33831")
		selected_icon.show()
	else:
		option_icon.self_modulate = Color("#2e222f")
		selected_icon.hide()
	



func _on_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
