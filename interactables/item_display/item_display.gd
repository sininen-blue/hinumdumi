extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"
@export var item: String
@export var item_node: String


@onready var point_light: PointLight2D = $PointLight2D


func _ready() -> void:
	if State.inventory.has(item):
		point_light.visible = true

func action() -> void:
	State.current_item = item
	State.current_item_node = item_node
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
