extends Node2D
@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var anim_big : AnimationPlayer = $"Big Crab/AnimationPlayer"
@onready var anim_player : AnimationPlayer = $Player/AnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D
@onready var big_crab : Sprite2D = $"Big Crab"
@onready var player : Sprite2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("player_idle")
	
	sprite.frame = 8
	await get_tree().create_timer(0.25).timeout
	sprite.frame = 9
	await get_tree().create_timer(2).timeout
	sprite.frame = 8
	await get_tree().create_timer(0.25).timeout
	
	anim.play("crab_walking")
	
	for i in range(10):
		sprite.position.x -= 20
		await get_tree().create_timer(0.25).timeout
	
	anim_big.play("crab_walking")
	
	for i in range(5):
		big_crab.position.x += 30
		await get_tree().create_timer(0.25).timeout
	
	anim_big.stop()
	big_crab.frame = 4
	
	await get_tree().create_timer(1).timeout
	
	player.flip_h = false
	anim_player.play("player_run")
	anim_big.play("crab_walking")

	for i in range(10):
		player.position.x += 20
		big_crab.position.x += 10
		await get_tree().create_timer(0.10).timeout
		
	for i in range(20):
		big_crab.position.x += 10
		await get_tree().create_timer(0.10).timeout
		
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
