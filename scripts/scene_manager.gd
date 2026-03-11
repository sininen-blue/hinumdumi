extends Node

@export var default_scene: PackedScene
@export var current_node: Node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	var node: Node = default_scene.instantiate()
	self.add_child.call_deferred(node)
	
	current_node = node
	State.player = find_player()
	State.popups = find_popup()
	
	music.play()


func change_scene_to(target: PackedScene) -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	current_node.queue_free()
	animation_player.play("fade_out")
	
	var new_node: Node = target.instantiate()
	self.add_child.call_deferred(new_node)
	current_node = new_node
	State.player = find_player()
	State.popups = find_popup()

func find_player() -> Player:
	var children: Array[Node] = current_node.get_children()
	var player: Player
	
	for child: Node in children:
		if child.is_in_group("player"):
			player = child
			break
	return player


func find_popup() -> Control:
	var popup: Control = current_node.find_child("Popups")
	return popup
