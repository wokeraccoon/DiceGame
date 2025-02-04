class_name FloatingText
extends Control

@export var presets_list : Dictionary[ColorPresets,Color] = {}

enum ColorPresets {
	DICE_VALUE,
	DAMAGE,
	MONEY
}
@export var current_preset : ColorPresets

@onready var background_color: ColorRect = %BackgroundColor
@onready var foreground_color: ColorRect = %ForegroundColor
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func start_floating_text(text : String):
	label.text = text
	
	match current_preset:
		
		ColorPresets.DICE_VALUE:
			background_color.color = presets_list[ColorPresets.DICE_VALUE]
	
func _ready() -> void:
	animation_player.play("DEFAULT")
