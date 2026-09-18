extends CharacterBody2D

@export var move_speed : float = 30
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200

var move_input : float

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer

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
		velocity.x = move_speed * 0.5
	else:
		velocity.x = move_speed 
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		print("jump")
	elif Input.is_action_just_pressed("jump"):
		velocity.y += -jump_force * .02
		print("jump")
		
	move_and_slide()
