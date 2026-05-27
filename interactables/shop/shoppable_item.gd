extends Node3D

class_name ShoppableItem

signal interacted(shoppable: ShoppableItem)

@export var item: Item = preload("res://interactables/items/Default.tres")
@export var amount: int = 1
@export var rotate_speed: float = 1
@export var item_offset: float = 0.1

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


func interact() -> void:
	interacted.emit(self)


func remove_stock() -> void:
	models.get_child(-1).call_deferred("queue_free")
