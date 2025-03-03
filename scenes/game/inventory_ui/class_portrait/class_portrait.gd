class_name ClassPortrait
extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_player_damage() -> void:
	animation_player.play("DAMAGE")
	
func on_player_heal() -> void:
	animation_player.play("HEALING")
