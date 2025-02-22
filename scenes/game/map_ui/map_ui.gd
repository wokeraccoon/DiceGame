@tool
class_name MapUI
extends Control

const MAP_OPTION = preload("res://scenes/game/map_ui/map_option.tscn")

@onready var map_steps_h_box: HBoxContainer = %MapStepsHBox
@onready var camera_2d: Camera2D = %Camera2D

@export var map_lenght : int = 9
@export_tool_button("generate") var generate_map : Callable = _generate_map

func _ready() -> void:
	_generate_map()

func _generate_map() -> void:
	
	for child : Node in map_steps_h_box.get_children():
		child.queue_free()
		
	for step_number : int in map_lenght:
		var vbox : VBoxContainer = VBoxContainer.new()
		map_steps_h_box.add_child(vbox)
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var button_ammount : int = 1
		
		if step_number == 0 or step_number == map_lenght -1 or step_number%2 == 1:
			button_ammount = 1
		else:
			button_ammount = 2
		
		for ammount : int in button_ammount:
			var new_option : MapOption = MAP_OPTION.instantiate()
			vbox.add_child(new_option)
			
			if step_number == 0:
				new_option.set_type(MapOption.Types.FIGHT)
			elif step_number == map_lenght -1:
				new_option.set_type(MapOption.Types.BOSS)
			else:
				#new_option.set_type(randi_range(2,MapOption.Types.size() - 2))
				if step_number%2 == 1:
					new_option.set_type(MapOption.Types.FIGHT)
				else:
					var random_options_type : MapOption.Types = [
						MapOption.Types.FIGHT,
						MapOption.Types.SHOP,
						MapOption.Types.CHEST,
						MapOption.Types.RANDOM].pick_random()
					
					new_option.set_type(random_options_type)
			
			new_option.option_selected.connect(_on_option_selected)
			
			
var map_steps_children : Array[VBoxContainer] = []

var current_vbox : int = 0

func _process(delta: float) -> void:
	
	if !Engine.is_editor_hint():
		if map_steps_children.is_empty():
			for child : Node in map_steps_h_box.get_children():
				if child is VBoxContainer:
					var vbox : VBoxContainer = child
					map_steps_children.append(vbox)
			
			camera_2d.global_position = map_steps_children[0].global_position
			camera_2d.offset = map_steps_children[0].size/2
			
			for child : Node in map_steps_children[0].get_children():
				if child is Button:
					child.disabled = false
			
		else:
			var target_pos : Vector2 = map_steps_children[current_vbox].global_position
			var target_offset : Vector2 = map_steps_children[current_vbox].size / 2
			
			camera_2d.global_position = lerp(camera_2d.global_position,target_pos,delta * 20)
			camera_2d.offset = lerp(camera_2d.offset,target_offset, delta * 20)
			
			
			if Input.is_action_just_pressed("ui_accept"):
				for child : Node in map_steps_children[current_vbox].get_children():
					if child is Button:
						child.disabled = true
						
				current_vbox += 1
				
				if current_vbox > map_steps_children.size() - 1:
					current_vbox = 0
				
				for child : Node in map_steps_children[current_vbox].get_children():
					if child is Button:
						child.disabled = false

func _on_option_selected(option_type : MapOption.Types) -> void:
	print(option_type)
