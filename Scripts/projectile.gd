extends CharacterBody2D

var speed = 100
var direction : float
var rotate : float
var spawn_position : Vector2

func _ready():
	global_position = spawn_position
	global_rotation = rotation

func _physics_process(delta: float) -> void:
	velocity = Vector2(-speed, 0).rotated(direction)
	move_and_slide()
