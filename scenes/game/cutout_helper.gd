extends MarginContainer

func _ready() -> void:
	if OS.has_feature('mobile'):
		show()
		var display_cutouts : Array[Rect2] = DisplayServer.get_display_cutouts()
		var cutout_size : Vector2 = display_cutouts[0].size
		
		custom_minimum_size.x = cutout_size.x
	else:
		hide()
