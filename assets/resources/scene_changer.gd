extends Area2D

@export var target_scene: PackedScene


# TODO: figure out proper scene structure for transisitons
func action() -> void:
	get_tree().change_scene_to_packed(target_scene)
