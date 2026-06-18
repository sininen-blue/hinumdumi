extends Control

@export var target: PackedScene


func _on_timer_timeout() -> void:
	SceneManager.change_scene(target)
