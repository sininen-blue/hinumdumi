extends Control

@export var target_scene: PackedScene

func _on_texture_button_pressed() -> void:
	SceneManager.change_scene_to(target_scene)
