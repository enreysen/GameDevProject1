extends RigidBody2D

@export var move_direction: Vector2
@export var move_speed : float = .5

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var anim : AnimationPlayer = $AnimationPlayer

var player: Node2D = null
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# walk towards player
	direction =  player.global_position.x - global_position.x
	global_position.x += direction * move_speed * delta

func _manage_animation():
	anim.play("crab_walking")
