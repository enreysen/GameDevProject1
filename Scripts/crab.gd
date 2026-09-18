extends Area2D

@export var move_direction: Vector2
@export var move_speed : float = 20
@onready var anim : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 0.5
	
	_manage_animation()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.queue_free()
		print("Remove Player")
		
		# wait 2 seconds
		await get_tree().create_timer(2.0).timeout
		
		# restart level, later on I'll add ending scene if I have time
		get_tree().reload_current_scene()
	
func _manage_animation():
	anim.play("crab_walking")
