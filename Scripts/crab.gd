extends Area2D

@export var move_direction: Vector2
@onready var health = $HealthBar
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node_2d: Node2D = $"."

var mini_crab = preload("res://Scenes/mini_crab.tscn")
var max_health : float = 300
var underwater  = false
var floor = 550
var ceiling = 375
var going_to_ceiling = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.value = max_health
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")
	
	if not underwater:
		health.position = Vector2(-125, -164)
	else:
		health.position = Vector2(-125, -100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not underwater:
		if health.value > max_health / 2:
			position.x += 0.5
		else: 
			print("crab angry")
			position.x += 0.70
	else:
		position.x += 0.5
		
		# head to ceiling or floor
		if position.y == ceiling:
			going_to_ceiling = false
		elif position.y == floor:
			going_to_ceiling = true
		
		# go up if heading towards ceiling, otherwise go down
		if going_to_ceiling:
			position.y -= 0.5
		else:
			position.y += 0.5
		
	_manage_animation()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# restart level
		get_tree().reload_current_scene()
	
	# if projectile hits crab hit box, remove health and remove projectile
	if body.is_in_group("Projectile"):
		print("Crab Health:", health.value)
		if health.value > max_health / 2:
			print("half health mode")
			_remove_health()
			body.queue_free()
		else:
			position.x -= 5
	else:
		print("hello")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Mini_Crabs"):
		print("Mini crabs!")
		throw_mini_crabs()
	else:
		print('bruh')
	
func _remove_health():
		health.value -= 1
		print("Crab health: ", health.value)
	
func _manage_animation():
	anim.play("crab_walking")
	
func throw_mini_crabs():
	for i in range(5):
		var crab = mini_crab.instantiate()
		crab.direction = rotation
		crab.spawn_position = (node_2d.global_position) - Vector2(100 * i, 20*i)
		crab.rotate = global_rotation
		get_parent().add_child(crab)
		
		await get_tree().create_timer(1.0).timeout
