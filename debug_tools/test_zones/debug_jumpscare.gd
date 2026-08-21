extends Node3D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reset"):
		get_tree().reload_current_scene()
