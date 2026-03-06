extends Area2D

@export var target_scene_path: String

func action() -> void:
	var loaded: PackedScene = load(target_scene_path)
	SceneManager.change_scene_to(loaded)
