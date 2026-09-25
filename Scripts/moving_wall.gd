extends AnimatableBody2D
@onready var node_2d: Node2D = $"."
@onready var camera = $Camera2D
var underwater = false
var tutorial = false
var wall_speed = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")
		
	if node_2d.has_meta("is_tutorial"):
		tutorial = node_2d.get_meta("is_tutorial")

func _physics_process(delta: float) -> void:
	if underwater:
		if not tutorial:
			camera.zoom = Vector2(2.0, 2.0)
			position.x += wall_speed * delta
		else:
			position.y -= wall_speed * delta
	else:
		position.x += wall_speed * delta
