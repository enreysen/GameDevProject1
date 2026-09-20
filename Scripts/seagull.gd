extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 50

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var anim : AnimationPlayer = $AnimationPlayer

var wall = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_manage_animation()
	
func _physics_process(delta: float) -> void:
	# I do not want the seagulls to start moving forward until they encounter the wall
	# this way I do not have to calculate where there position should be
	if wall:
		global_position = global_position.move_toward(target_pos, move_speed * delta)
		#if global_position == target_pos:
			#if target_pos == start_pos:
				#target_pos = start_pos + move_direction
			#else:
				#target_pos = start_pos


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("stun"):
			body.stun()
	
	if body.is_in_group("Wall"):
		wall = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("unstun"):
			body.unstun()

func _manage_animation():
	anim.play("seagull")
