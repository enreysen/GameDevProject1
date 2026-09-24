extends Node2D

@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var anim_player : AnimationPlayer = $Player/AnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D
@onready var player : CharacterBody2D = $Player
@onready var player_sprite: Sprite2D = get_tree().get_first_node_in_group("Player").get_node("Sprite")

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_1.visible = false
	label_2.visible = false
	label_3.visible = false
	
	anim_player.play("player_walk")
	anim.play("crab_walking")
	for i in range(250):
		player.position.x += 1
		await get_tree().create_timer(0.01).timeout

	for i in range(50):
		player.position.x += 1
		sprite.position.x += 2
		await get_tree().create_timer(0.01).timeout
		
	anim_player.play("player_idle")
	anim.stop()
	
	await get_tree().create_timer(1).timeout
	label_1.visible = true
	player_sprite.flip_h = true
	await get_tree().create_timer(2).timeout
	label_1.visible = false
	label_2.visible = true
	
	await get_tree().create_timer(2).timeout
	label_2.visible = false
	label_3.visible = true
	
	await get_tree().create_timer(2).timeout
	player_sprite.flip_h = false
	anim_player.play("player_run")

	for i in range(10):
		player.position.x += 1
		sprite.position.x += 2
		await get_tree().create_timer(0.01).timeout
		
	get_tree().change_scene_to_file("res://Scenes/tutorial_2.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
