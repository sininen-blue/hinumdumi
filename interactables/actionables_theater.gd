extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"

@export var anim: AnimationPlayer


# TODO: make this an actual balloon
func action() -> void:
	anim.play("play")


func talk() -> void:
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
