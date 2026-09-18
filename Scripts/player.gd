extends CharacterBody2D

@export var move_speed : float = 30
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200

var bullet_path = preload("res://Scenes/projectile.tscn")

var move_input : float

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node_2d: Node2D = $"."

# flip sprite
func _process(delta: float):
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_input = Input.get_axis("move_left", "move_right")
	# idea is player keeps moving forward
	# they move faster if looking right, slower if looking left
	if move_input == 1.0:
		velocity.x = 2 * move_speed
	elif move_input == -1.0:
		# player shoots when looking backwards
		velocity.x = move_speed * 0.5
		
	else:
		velocity.x = move_speed 
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	elif Input.is_action_just_pressed("jump"):
		velocity.y += -jump_force * .02
		
	move_and_slide()

# got this section from the following tutorial:
# "Simple Shooting system in Godot4 2D | godot tutorial" by GameStick on YouTube
func shoot():
	var bullet = bullet_path.instantiate()
	bullet.direction = rotation
	bullet.spawn_position = (node_2d.global_position) - Vector2(20, 0)
	bullet.rotate = global_rotation
	get_parent().add_child(bullet)
