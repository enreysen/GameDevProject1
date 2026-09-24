extends Area2D
@onready var lose_screen : Area2D = $"."
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if lose_screen.is_in_group("Lose Level 1"):
			get_tree().change_scene_to_file("res://Scenes/lose_level_1.tscn")
		if lose_screen.is_in_group("Lose Level 2"):
			get_tree().change_scene_to_file("res://Scenes/lose_level_2.tscn")
