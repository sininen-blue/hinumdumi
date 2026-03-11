extends Control

@export var target_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("play")


func _on_texture_button_pressed() -> void:
	SceneManager.change_scene_to(target_scene)
