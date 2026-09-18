extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 0.5

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
		
	print("Deal Damage to Player")
