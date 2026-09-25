extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 50
@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var sprite : Sprite2D = $Sprite2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var node : Area2D = $"."

var wall = false
var anim_name : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.flip_h = true
	_manage_animation()

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	#if wall:
		#print("wall")
	global_position = global_position.move_toward(target_pos, move_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("slow"):
			body.slow()

	if body.is_in_group("Wall"):
		wall = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("unslow"):
			body.unslow()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Crab"):
		queue_free()

func _manage_animation():
	if node.is_in_group("slow_fish_1"):
		anim_name = "slow_fish_1"
	elif node.is_in_group("slow_fish_2"):
		anim_name = "slow_fish_2"
	elif node.is_in_group("slow_fish_3"):
		anim_name = "slow_fish_3"
		
	if anim_name != "":
		# prevent all jellyfish moving in unison
		anim.play(anim_name)
		var anim_length: float = anim.get_animation(anim_name).length
		anim.seek(randf_range(0.0, anim_length), true)
