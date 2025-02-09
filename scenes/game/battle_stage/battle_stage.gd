class_name BattleStage
extends Node3D

@onready var enemy_animation_player: AnimationPlayer = $EnemyAnimationPlayer
@onready var player_animation_player: AnimationPlayer = $PlayerAnimationPlayer
@onready var enemy_sprite: Sprite3D = %EnemySprite

signal battle_ready
signal player_attacked
signal enemy_attacked
signal enemy_died
signal player_died

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		player_dead()

func _ready() -> void:
	player_animation_player.play("PLAYER_IDLE")

func set_enemy_sprite(texture : Texture2D):
	enemy_sprite.texture = texture

func start_intro() -> void:
	enemy_animation_player.play("ENEMY_IDLE")
	player_animation_player.play("PLAYER_INTRO")

func player_turn() -> void:
	enemy_animation_player.play("ENEMY_IDLE")
	player_animation_player.play("PLAYER_IDLE")

func player_attack() -> void:
	player_animation_player.play("PLAYER_ZOOM_IN")
	await player_animation_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	enemy_animation_player.play("ENEMY_HIT")
	await enemy_animation_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	enemy_animation_player.play("ENEMY_IDLE")
	player_attacked.emit()

func enemy_attack() -> void:
	player_animation_player.play("PLAYER_ZOOM_OUT")
	await player_animation_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	enemy_animation_player.play("ENEMY_ATTACK")
	await player_animation_player.animation_finished
	player_animation_player.play("PLAYER_IDLE")
	enemy_attacked.emit()
	
func enemy_dead() -> void:
	player_animation_player.play("PLAYER_ZOOM_OUT")
	await player_animation_player.animation_finished
	enemy_animation_player.play("ENEMY_DEATH")
	await enemy_animation_player.animation_finished
	await get_tree().create_timer(0.25).timeout
	player_animation_player.play("PLAYER_OUTRO")
	await player_animation_player.animation_finished
	enemy_died.emit()
	

func player_dead() -> void:
	enemy_animation_player.play("ENEMY_IDLE")
	player_animation_player.play("PLAYER_DEATH")
	await player_animation_player.animation_finished
	player_died.emit()
