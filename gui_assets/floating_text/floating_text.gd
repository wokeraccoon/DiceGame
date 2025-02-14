@tool
class_name FloatingText
extends Control

@export var presets_list : Dictionary[ColorPresets,Color] = {}

enum ColorPresets {
	PLAYER_DAMAGE,
	ENEMY_DAMAGE,
	MONEY_ADDED
}
@export var current_preset : ColorPresets

@export_tool_button("Change Color") var change_color_func : Callable = _set_color

@onready var background_color: ColorRect = %BackgroundColor
@onready var foreground_color: ColorRect = %ForegroundColor
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_floating_text(text : String, color_preset : ColorPresets):
	label.text = text
	current_preset = color_preset
	_set_color()

func _set_color() -> void:
	background_color.color = presets_list[current_preset]
	foreground_color.color = presets_list[current_preset]
	
func _ready() -> void:
	animation_player.play("DEFAULT")
