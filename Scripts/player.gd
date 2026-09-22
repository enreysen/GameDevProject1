extends CharacterBody2D

@export var move_speed : float = 30
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200
@export var stunned : bool = false

var bullet_path = preload("res://Scenes/projectile.tscn")

var move_input : float

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node_2d: Node2D = $"."
@onready var air: ProgressBar = $"../Moving Wall/Air Remaining"

var underwater = false

func _ready() -> void:
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")
	
	if underwater: 
		air.value = 100

# flip sprite
func _process(delta: float):
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0

func _physics_process(delta: float) -> void:
	if not is_on_floor(): # how fast the player falls
		if not underwater:
			velocity.y += gravity * delta
		else:
			velocity.y += (gravity * delta) / 1.5
		
	if stunned:
		move_speed = 0
	else:
		move_speed = 30
		
	move_input = Input.get_axis("move_left", "move_right")
	
	# idea is player keeps moving forward
	# they move faster if looking right, slower if looking left
	if move_input == 1.0:
		velocity.x = 2 * move_speed
	elif move_input == -1.0:
		velocity.x = move_speed * 0.5
	else:
		velocity.x = move_speed 
	
	# shoot projectile
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	# jump
	if Input.is_action_pressed("jump") and not stunned:
		if not underwater:
			if is_on_floor():
				velocity.y = -jump_force
			elif Input.is_action_just_pressed("jump"):
				velocity.y += -jump_force * .02
				
		else: 
			velocity.y = -jump_force / 4
		
	# remove air		
	if underwater:
		air.value -= 0.025
	
	move_and_slide()

# got this section from the following tutorial:
# "Simple Shooting system in Godot4 2D | godot tutorial" by GameStick on YouTube
func shoot():
	var bullet = bullet_path.instantiate()
	bullet.direction = rotation
	bullet.spawn_position = (node_2d.global_position) - Vector2(20, 0)
	bullet.rotate = global_rotation
	get_parent().add_child(bullet)
	

func stun():
	stunned = true
	await get_tree().create_timer(2.0).timeout 
	unstun()

func unstun():
	stunned = false

func add_air():
	air.value += 25
