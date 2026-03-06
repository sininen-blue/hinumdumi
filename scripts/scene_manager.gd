extends Node

@export var default_scene: PackedScene
@export var current_node: Node

func _ready() -> void:
	var node: Node = default_scene.instantiate()
	self.add_child.call_deferred(node)
	
	current_node = node

func change_scene_to(target: PackedScene) -> void:
	current_node.queue_free()
	
	var new_node: Node = target.instantiate()
	self.add_child.call_deferred(new_node)
	current_node = new_node
