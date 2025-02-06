class_name BattleStage
extends Node3D

signal battle_stage_ready

@onready var enemy_animation_player: AnimationPlayer = $EnemyAnimationPlayer
@onready var player_animation_player: AnimationPlayer = $PlayerAnimationPlayer
@onready var enemy_sprite: Sprite3D = %EnemySprite

enum BattleStates {
	INTRO,
	WAIT_FOR_PLAYER,
	PLAYER_ATTACK,
	WAIT_FOR_ENEMY,
	ENEMY_ATTACK,
	VICTORY,
	LOST_BATTLE
}

var battle_state : BattleStates = BattleStates.INTRO

func set_enemy_sprite(texture : Texture2D):
	enemy_sprite.texture = texture

func _process(delta: float) -> void:
	
	match battle_state:
		BattleStates.INTRO:
			if !enemy_animation_player.is_playing():
				enemy_animation_player.play("ENEMY_IDLE")
			
			if !player_animation_player.is_playing():
				player_animation_player.play("PLAYER_INTRO")
		BattleStates.WAIT_FOR_PLAYER:
			if !enemy_animation_player.is_playing():
				enemy_animation_player.play("ENEMY_IDLE")
			if !player_animation_player.is_playing():
				player_animation_player.play("PLAYER_IDLE")
		BattleStates.WAIT_FOR_ENEMY:
			if !enemy_animation_player.is_playing():
				enemy_animation_player.play("ENEMY_IDLE")
		

func _on_battle_stage_ready() -> void:
	battle_state = BattleStates.WAIT_FOR_PLAYER

func hit_enemy() -> void:
	if BattleStates.WAIT_FOR_PLAYER:
		battle_state = BattleStates.PLAYER_ATTACK
		player_animation_player.stop()
		player_animation_player.play("PLAYER_ZOOM_IN")
		await get_tree().create_timer(1).timeout
		enemy_animation_player.stop()
		enemy_animation_player.play("ENEMY_HIT")
		await get_tree().create_timer(1).timeout
		#player_animation_player.play("PLAYER_ZOOM_OUT")
		battle_state = BattleStates.WAIT_FOR_ENEMY
		

func hit_player() -> void:
	pass
