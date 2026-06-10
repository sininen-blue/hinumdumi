extends Node3D

@export var play_level: PackedScene = preload("res://levels/Demo/demo_level_1.tscn")


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(play_level)
