extends Node

func _ready() -> void:
	
	if OS.has_feature('pc'):
	
		if OS.get_distribution_name() == "SteamOS":
			get_tree().root.size = Vector2(1280,800)
			get_tree().root.mode = Window.MODE_FULLSCREEN
