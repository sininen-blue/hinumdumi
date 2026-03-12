extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"


@onready var point_light: PointLight2D = $PointLight2D


func _ready() -> void:
	if State.mail_length() >= 8:
		point_light.visible = true

func action() -> void:
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
