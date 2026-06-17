extends Node3D

@export var play_level: PackedScene = preload("res://levels/Demo/demo_level_1.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("camera_bob")


func _on_play_button_pressed() -> void:
	SceneManager.change_scene(play_level)
