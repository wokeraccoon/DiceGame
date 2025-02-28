extends MarginContainer

func _ready() -> void:
	if OS.has_feature('mobile'):
		show()
		var display_cutout : Rect2i = DisplayServer.get_display_safe_area()
		
		size.x = display_cutout.position.x
		
	else:
		hide()
