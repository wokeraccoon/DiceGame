class_name DebugStatsPanel
extends Control

@onready var specs_label: Label = %SpecsLabel
@onready var fps_label: Label = %FPSLabel

func _ready() -> void:
	specs_label.text = "" # 1

	specs_label.text += "OS: " + OS.get_name() + "\n" # 2
	specs_label.text += "Distro: " + OS.get_distribution_name() + "\n" # 3
	specs_label.text += "CPU: " + OS.get_processor_name() + "\n" # 4
	specs_label.text += "GPU: " + RenderingServer.get_rendering_device().get_device_name() # 5

func _process(delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"
