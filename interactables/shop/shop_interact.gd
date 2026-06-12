extends Area3D

class_name ShopInteract

signal interacted(item: Item)

@export var item: Item


func interact() -> void:
	interacted.emit(item)
