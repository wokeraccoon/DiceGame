class_name Item
extends Resource

@export var item_name : String
@export_multiline var tagline : String
@export_multiline var description : String
@export var item_texture : Texture2D = preload("res://icon.svg")

var item_ammount : int = 0
