class_name ComboReferenceUI
extends Control

@onready var back_button: Button = %BackButton
@onready var combo_showcase: CenterContainer = %ComboShowcase

const FOUR_OF_A_KIND_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/four_of_a_kind_dice.tscn")
const FULL_HOUSE_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/full_house_dice.tscn")
const PAIR_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/pair_dice.tscn")
const SINGLES_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/singles_dice.tscn")
const STRAIGHT_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/straight_dice.tscn")
const THREE_OF_A_KIND_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/three_of_a_kind_dice.tscn")
const TWO_PAIR_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/two_pair_dice.tscn")
const YATCH_DICE = preload("res://scenes/game/managers/battle_manager/battle_stage/battle_ui/player_dice_ui/dice_reference_ui/yatch_dice.tscn")

func _ready() -> void:
	update_showcase(SINGLES_DICE)

func _on_back_button_pressed() -> void:
	hide()

func _on_draw() -> void:
	back_button.grab_focus()


func update_showcase(combo_scene : PackedScene) -> void:
	combo_showcase.get_children()[0].queue_free()
	var combo : Control = combo_scene.instantiate()
	combo_showcase.add_child(combo)

func _on_singles_button_pressed() -> void:
	update_showcase(SINGLES_DICE)

func _on_pair_button_pressed() -> void:
	update_showcase(PAIR_DICE)


func _on_two_pair_button_pressed() -> void:
	update_showcase(TWO_PAIR_DICE)


func _on_three_kind_button_pressed() -> void:
	update_showcase(THREE_OF_A_KIND_DICE)


func _on_four_kind_button_pressed() -> void:
	update_showcase(FOUR_OF_A_KIND_DICE)


func _on_full_house_button_pressed() -> void:
	update_showcase(FULL_HOUSE_DICE)


func _on_straight_button_pressed() -> void:
	update_showcase(STRAIGHT_DICE)


func _on_yatch_button_pressed() -> void:
	update_showcase(YATCH_DICE)
