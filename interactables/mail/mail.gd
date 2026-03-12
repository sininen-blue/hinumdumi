extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"
@export var sender: String = ""
@export_multiline var message: String

func _ready() -> void:
	$AnimationPlayer.play("bob")

func action() -> void:
	var mail: Dictionary = {
		"sender": sender,
		"message": message.split("\n")
	}
	State.mailbox.append(mail)
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
	
	self.call_deferred("queue_free")
