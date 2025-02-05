class_name BattleStage
extends Node3D

signal battle_stage_ready

@onready var enemy_animation_player: AnimationPlayer = $EnemyAnimationPlayer
@onready var player_animation_player: AnimationPlayer = $PlayerAnimationPlayer

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
		

func _on_battle_stage_ready() -> void:
	battle_state = BattleStates.WAIT_FOR_PLAYER
