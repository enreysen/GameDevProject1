extends CharacterBody2D

@export var move_direction: Vector2
@export var move_speed : float = 2
@export var gravity : float = 500
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D

var speed = 100
var direction : float
var rotate : float
var spawn_position : Vector2
var player: Node2D = null
var random_int = randi_range(1, 3) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	global_position = Vector2(spawn_position.x + 30, spawn_position.y - 30)
	global_rotation = rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else: 
		# ranomly jump
		random_int = randi_range(1, 20) 

		if random_int == 1:
			velocity.y -= 200
		elif random_int == 2:
			velocity.y -= 300
		elif random_int == 3:
			velocity.y -= 400

	# walk towards player
	direction =  player.global_position.x - global_position.x
	global_position.x += direction * move_speed * delta
	
	move_and_slide()

func _manage_animation():
	anim.play("crab_walking")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # stun player after contact
		if body.has_method("stun"):
			body.stun()
		
		collision.set_deferred("disabled", true)
		await get_tree().create_timer(1.0).timeout

		if body.has_method("unstun"):
			body.unstun()
			
		queue_free()

	elif body.is_in_group("Projectile"): # remove mini crab after it hits projectile
		body.queue_free()
		queue_free()
	else:
		print(body.get_groups())
