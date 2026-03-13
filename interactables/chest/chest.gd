extends Area2D

@export var balloon: PackedScene = load("res://dialogue/balloon/balloon.tscn")
@export var dialogue: DialogueResource
@export var start: String = "start"
@export var item: String
@export var item_node: String

var is_empty: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if State.inventory.get(item):
		$Sprite.frame = 1

func action() -> void:
	if is_empty == false:
		animation_player.play("open")
		await animation_player.animation_finished
	is_empty = true
	
	State.current_item = item
	State.current_item_node = item_node
	State.inventory[item] = true
	DialogueManager.show_dialogue_balloon_scene(balloon, dialogue, start)
	
