extends Node

func _ready() -> void:
	
	if OS.has_feature('pc'):
		get_tree().root.content_scale_factor = 0.8
