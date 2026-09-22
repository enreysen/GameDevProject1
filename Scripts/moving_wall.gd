extends AnimatableBody2D
@onready var node_2d: Node2D = $"."
@onready var camera = $Camera2D
var underwater = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if node_2d.has_meta("is_underwater"):
		underwater = node_2d.get_meta("is_underwater")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if underwater: 
		camera.zoom = Vector2(2.0, 2.0)

	position.x += 1
