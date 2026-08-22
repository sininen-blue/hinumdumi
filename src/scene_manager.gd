extends Node

const TRANSITION: PackedScene = preload("res://ui/transition/transition_root.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_out")


func change_scene(target: PackedScene, level_transition: bool = false, night: int = 1, missing: int = 1) -> void:
	animation_player.play("fade_in")

	await animation_player.animation_finished
	if level_transition:
		animation_player.play("fade_out")
		var transition_instance: LevelTransition = TRANSITION.instantiate()
		transition_instance.night_number = night
		transition_instance.missing_number = missing
		add_child(transition_instance)
		await transition_instance.done_transition
		animation_player.play("fade_in")
		
		await animation_player.animation_finished
		remove_child(transition_instance)
		get_tree().change_scene_to_packed(target)
	else:
		get_tree().change_scene_to_packed(target)

	await get_tree().scene_changed
	animation_player.play("fade_out")
