extends StaticBody2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile"):
		print("projectile")
		body.queue_free()
		collision.set_deferred("disabled", true)
		_manage_animation()
		await $AnimationPlayer.animation_finished
		queue_free()
		
	elif body.is_in_group("Crab"):
		print("crab")
		_manage_animation()
		
func _manage_animation():
	anim.play("destroy_barrel")
