extends Area2D

@export var target_scene_path: String
@export var need_key: bool = false

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var enter_dialogue: DialogueResource
@export var start: String = "start"

func action() -> void:
	if need_key:
		if !State.has_key:
			DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
			return
		else: 
			DialogueManager.show_dialogue_balloon_scene(balloon, enter_dialogue, start)
			await DialogueManager.dialogue_ended
	var loaded: PackedScene = load(target_scene_path)
	SceneManager.change_scene_to(loaded)
