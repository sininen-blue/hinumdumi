extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_out")


func change_scene(target: PackedScene) -> void:
	animation_player.play("fade_in")

	await animation_player.animation_finished
	get_tree().change_scene_to_packed(target)

	await get_tree().scene_changed
	animation_player.play("fade_out")
