extends Node2D

@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var anim_player : AnimationPlayer = $Player/AnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D
@onready var player : CharacterBody2D = $Player
@onready var player_sprite: Sprite2D = get_tree().get_first_node_in_group("Player").get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("player_run")
	anim.play("crab_walking")

	for i in range(16):
		player.position.x += 2
		sprite.position.x += 2
		await get_tree().create_timer(0.1).timeout
		
	anim.stop()
	anim_player.play("player_jump")
	await get_tree().create_timer(0.5).timeout
	player.position.x += 20
	
	player_sprite.frame = 29
	for i in range(60):
		player.position.x += 0.5
		player.position.y += 4
		await get_tree().create_timer(0.001).timeout
	
	anim.play("crab_walking")
	for i in range(60):
		sprite.position.x += 0.5
		await get_tree().create_timer(0.001).timeout
		
	get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")
