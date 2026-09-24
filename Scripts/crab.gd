extends Area2D

@export var move_direction: Vector2
@onready var health = $HealthBar
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node_2d: Node2D = $"."
@onready var player: CharacterBody2D = $"../CharacterBody2D"

var mini_crab = preload("res://Scenes/mini_crab.tscn")
var max_health : float
var underwater  = false
var tutorial  = false
var ceiling = 375
var going_to_ceiling = true
var animation : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_manage_animation("crab_walking")
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")
		
	if node_2d.has_meta("is_tutorial"):
		tutorial = node_2d.get_meta("is_tutorial")
		
	if not underwater and not tutorial:
		max_health = 300
	elif tutorial:
		max_health = 50
	
	health.max_value = max_health
	health.value = max_health
	
	if not underwater and not tutorial:
		health.position = Vector2(-125.0, -164.0)
	elif not underwater and tutorial:
		health.position = Vector2(-75.0, -170.0)
	else:
		health.position = Vector2(-125.0, -100.0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# movement speed
	if not underwater and health.value > max_health / 2:
			position.x += 0.50
	else: 
		if not underwater and not tutorial:
			position.x += 0.50
		elif underwater and not tutorial:
			position.x += 0.70
			global_position.y = player.global_position.y + 15
		elif tutorial:
			position.x += 0.50
			
	if health.value <= 0 and tutorial:
		get_tree().change_scene_to_file("res://scenes/tutorial_to_main.tscn")
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# restart level
		get_tree().reload_current_scene()
	
	# if projectile hits crab hit box, remove health and remove projectile
	if body.is_in_group("Projectile"):
		if health.value > max_health / 2 and not underwater:
			_remove_health()
		else:
			if not underwater and not tutorial:
				position.x -= 5
			elif not tutorial:
				position.x -= 10
				_remove_health()
			elif tutorial:
				_remove_health()
		
		body.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Mini_Crabs"):
		print("Mini crabs!")
		throw_mini_crabs()
	
func _remove_health():
		health.value -= 1
	
func _manage_animation(animation : String):
	anim.play(animation)
	
func throw_mini_crabs():
	for i in range(3):
		var crab = mini_crab.instantiate()
		
		# Random direction in a full circle
		var random_angle = randf_range(0, TAU)
		crab.move_direction = Vector2.RIGHT.rotated(random_angle)
		
		# Spawn at a random distance from crab
		var random_offset = Vector2.RIGHT.rotated(random_angle) * randf_range(0, 10)
		crab.spawn_position = node_2d.global_position + random_offset
		
		get_parent().add_child(crab)
		
		# Randomize spawn timing
		await get_tree().create_timer(1.5).timeout
