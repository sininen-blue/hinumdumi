extends Area2D


@export var dialogue: DialogueResource
@export var start: String = "start"


# TODO: make this an actual balloon
func action() -> void:
	DialogueManager.show_dialogue_balloon(dialogue, start)
