extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"


@onready var point_light: PointLight2D = $PointLight2D


func _ready() -> void:
	if len(State.inventory) >= 6:
		point_light.visible = true
		self.self_modulate = Color("#ffffff")
	else:
		self.self_modulate = Color("#4545456b")

func action() -> void:
	State.has_key = true
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
