extends Node
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var disappear : AudioStreamPlayer2D = $Disappear
@onready var collision : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_manage_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("stun"):
			body.stun()
			print("stun")
	
	if body.is_in_group("Projectile"):
		body.queue_free()
		anim.play("disappear")
		disappear.play()
		collision.set_deferred("disabled", true)
		await get_tree().create_timer(0.55).timeout 
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Crab"):
		queue_free()
		
func _manage_animation():
	anim.play("jellyfish")
	
	# prevent all jellyfish moving in unison
	var anim_length: float = anim.get_animation("jellyfish").length
	anim.seek(randf_range(0.0, anim_length), true)
