extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"


# TODO: make this an actual balloon
func action() -> void:
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
