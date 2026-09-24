extends Area2D
@onready var transition : Area2D = $"."
@onready var crab : Area2D = $"../Crab"
var progress_value: float = 0.0
var crab_max_health
	
var in_collision = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if transition.is_in_group("Level 1"):
		crab_max_health =  $"../Crab/HealthBar".max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# if the crab health is half or less, move to level 2
	if transition.is_in_group("Level 1"):
		progress_value = $"../Crab/HealthBar".value
		
		if progress_value <= crab_max_health / 2 and in_collision:
			get_tree().change_scene_to_file("res://scenes/Level_2.tscn")
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_collision = true

	if transition.is_in_group("Tutorial"):
		get_tree().change_scene_to_file("res://scenes/tutorial_1_to_2.tscn")
