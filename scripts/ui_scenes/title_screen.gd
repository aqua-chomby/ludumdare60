extends Control

@onready var start_game: Button = $VBoxContainer/StartGame


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	queue_free()
