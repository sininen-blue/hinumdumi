extends Node

@export var default_scene: PackedScene
@export var current_node: Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_player: int = 0

@onready var music1: AudioStreamPlayer = $Music1
@onready var music_2: AudioStreamPlayer = $Music2


func _ready() -> void:
	var node: Node = default_scene.instantiate()
	self.add_child.call_deferred(node)
	
	current_node = node
	State.player = find_player()
	State.popups = find_popup()
	
	music1.play()


func change_scene_to(target: PackedScene) -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	var new_node: Node = target.instantiate()
	State.player = find_player()
	if new_node.name != "LocalWorld" and State.player:
		State.last_local_world_position = State.player.global_position
	


	self.add_child.call_deferred(new_node)
	current_node.queue_free()
	current_node = new_node
	
	State.player = find_player()
	State.popups = find_popup()
	if new_node.name == "LocalWorld" and State.player:
		State.player.global_position = State.last_local_world_position

	
	animation_player.play("fade_out")


func find_player() -> Player:
	var player: Player = current_node.find_child("Player")
	return player


func find_popup() -> Control:
	var popup: Control = current_node.find_child("Popups")
	return popup
