class_name InventoryUI
extends MarginContainer

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var class_portrait: ClassPortrait = %ClassPortrait
@onready var money_label: Label = %MoneyLabel

var health_bar_value : int  = 0

func _process(delta: float) -> void:
	if health_bar_value == health_bar.max_value or health_bar_value <= 0:
		health_bar.value = health_bar_value
	else:
		health_bar.value = lerp(float(health_bar.value), float(health_bar_value), 25 * delta)

func update_player_health(health : int, max_health : int) -> void:
	if (health - health_bar_value) < 0:
		class_portrait.on_player_damage()
	else:
		class_portrait.on_player_heal()
	
	health_bar.max_value = max_health
	health_bar_value = health
	
	health_label.text = str(health,"/",max_health)
	
	if health_bar_value < 0:
		health_bar_value = 0

func update_player_money(money : int) -> void:
	money_label.text = "$" + str(money)

const ITEM_HOLDER = preload("res://scenes/game/inventory_ui/item_holder/item_holder.tscn")
@onready var item_grid: GridContainer = %ItemGrid

func update_item_grid(items : Array[Item]) -> void:
	for child : Node in item_grid.get_children():
		child.queue_free()
	
	for item : Item in items:
		var item_holder : ItemHolder = ITEM_HOLDER.instantiate()
		item_grid.add_child(item_holder)
		item_holder.update_item(item)
		
