class_name ComboReferenceUI
extends Control

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var back_button: Button = %BackButton

func _process(delta: float) -> void:
	var scroll_bar : VScrollBar = scroll_container.get_v_scroll_bar()
	
	if visible:
		
		if Input.is_action_pressed("ui_up"):
			scroll_bar.value = lerp(scroll_bar.value, scroll_bar.value - 100.0, 10 * delta)
		if Input.is_action_pressed("ui_down"):
			scroll_bar.value = lerp(scroll_bar.value, scroll_bar.value + 100.0, 10 * delta)

func _on_back_button_pressed() -> void:
	hide()

func _on_draw() -> void:
	back_button.grab_focus()
