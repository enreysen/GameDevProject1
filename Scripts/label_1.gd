extends Label
@onready var movement: Label = $"."
@onready var fish_slow: Label = $"../Fish Show Label"
@onready var pufferfish: Label = $"../Pufferfish Label"
@onready var jellyfish: Label = $"../Jellyfish"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	fish_slow.visible = false
	pufferfish.visible = false
	jellyfish.visible = false
	
	await get_tree().create_timer(5).timeout
	remove_label(movement)
	
	await get_tree().create_timer(3).timeout
	show_label(fish_slow)
	
	await get_tree().create_timer(6).timeout
	remove_label(fish_slow)
	
	show_label(pufferfish)
	await get_tree().create_timer(6).timeout
	remove_label(pufferfish)
	
	show_label(jellyfish)
	await get_tree().create_timer(5).timeout
	remove_label(jellyfish)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func remove_label(label : Label) -> void:
	label.visible = false

func show_label(label : Label) -> void:
	label.visible = true
	
