class_name Item
extends Resource

@export var item_name : String
@export_multiline var tagline : String
@export_multiline var description : String
@export var item_texture : Texture2D = preload("res://icon.svg")

enum Owners {
	PLAYER,
	ENEMY,
	NONE
}

var item_owner : Owners = Owners.NONE

@export_range(1,999,1) var item_ammount : int = 1

func on_item_added() -> void:
	pass

func on_item_ammount_increased() -> void:
	pass
	
func on_item_ammount_decreased() -> void:
	pass

func update_description() -> void:
	pass
	
const ITEM_PARTICLES = preload("res://gui_assets/item_particles.tscn")

func spawn_item_particles(parent_node : Node) -> void:
	var particles : CPUParticles2D = ITEM_PARTICLES.instantiate()
	parent_node.add_child(particles)
	particles.top_level = true
	particles.texture = item_texture
	particles.global_position = parent_node.global_position
	particles.emitting = true
