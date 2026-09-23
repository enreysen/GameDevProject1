extends Node
@onready var shoot: Label = $"Shoot Label"
@onready var jump: Label = $"Shoot Label/Jump Label"
@onready var seagull: Label = $"Shoot Label/Seagull Label"
@onready var crab: Label = $"Shoot Label/Crab Health"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		print("here")
		jump.visible = false
