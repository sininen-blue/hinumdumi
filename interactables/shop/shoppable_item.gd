extends Node3D

class_name ShoppableItem

signal interacted(shoppable: ShoppableItem)

@export var item: Item = preload("res://interactables/items/Default.tres")
@export var amount: int = 1
@export var rotate_speed: float = 1
@export var item_offset: float = 0.1

# Dictionary[Node3D: Hand]
var to_remove: Array[Dictionary] = []

@onready var label: Label3D = $Label
@onready var models: Node3D = $Models

@onready var interact_area: InteractArea = $InteractArea


func _ready() -> void:
	label.text = item.name

	var model: PackedScene = item.model

	for i in range(amount):
		var item_model: Node3D = model.instantiate()
		models.add_child(item_model)
		item_model.global_position += Vector3(item_offset, -item_offset, item_offset) * i


func _process(delta: float) -> void:
	for item_model: Node3D in models.get_children():
		item_model.rotate(Vector3(1, 1, 1).normalized(), rotate_speed * delta)

	for child: Dictionary[Node3D, Hand] in to_remove:
		var node: Node3D = child.keys()[0]
		var target: Hand = child[node]

		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(node, "global_position", target.global_position, 0.07)

		if (node.global_position - target.global_position).length() < 0.5:
			var qf_tween: Tween = get_tree().create_tween()
			qf_tween.tween_property(node, "scale", Vector3.ZERO, 0.1)

		if (node.scale - Vector3.ZERO).length() <= 0.2:
			node.call_deferred("queue_free")
			to_remove.erase(child)


func remove_stock(target: Hand) -> void:
	var obj: Node3D = models.get_child(-1)
	models.move_child(obj, 0)
	to_remove.append({ obj: target })


func _on_interact_area_interacted() -> void:
	interacted.emit(self)
