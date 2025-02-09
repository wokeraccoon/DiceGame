class_name DebugStatsPanel
extends Control

@onready var specs_label: Label = %SpecsLabel
@onready var fps_label: Label = %FPSLabel
@onready var os_stats_box: MarginContainer = $VBoxContainer/OSStatsBox

func _ready() -> void:
	if !OS.has_feature("web"):
		specs_label.text += "OS: " + OS.get_name()
		specs_label.text += "\n"
		specs_label.text += "Distro: " + OS.get_distribution_name() + "\n"
		specs_label.text += "CPU: " + OS.get_processor_name() + "\n"
		specs_label.text += "GPU: " + RenderingServer.get_rendering_device().get_device_name()
	else:
		os_stats_box.hide()
	
func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
