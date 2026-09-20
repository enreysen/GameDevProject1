extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 20
@onready var health = $HealthBar
@onready var anim : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.value = 100
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 0.5
	_manage_animation()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# restart level, later on I'll add ending scene if I have time
		get_tree().reload_current_scene()
	
	# if projectile hits crab hit box, remove health and remove projectile
	if body.is_in_group("Projectile"):
		_remove_health()
		body.queue_free()

	
func _remove_health():
		if health.value <= 0:
			get_tree().reload_current_scene() # I'll change later
		health.value -= 1
		print("Crab health: ", health.value)
	
func _manage_animation():
	anim.play("crab_walking")
