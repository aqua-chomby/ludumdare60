extends Node2D

@onready var wool_count: Label = $UIElements/GameplayUI/WoolCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wool_count.text = str("Wool: ", GameState.wool_count)
