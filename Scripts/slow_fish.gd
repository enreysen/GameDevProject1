extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 50

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var sprite : Sprite2D = $Sprite2D

var wall = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.flip_h = true

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	#if wall:
		#print("wall")
	global_position = global_position.move_toward(target_pos, move_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("entered")
		if body.has_method("slow"):
			body.slow()

	if body.is_in_group("Wall"):
		print("wall")
		wall = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("exit")
		if body.has_method("unslow"):
			body.unslow()
		
