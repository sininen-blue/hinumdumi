extends Node3D

class_name ShopDisplay

@export var item: Item
@export var initial_amount: int

var offset: float = 0.1
var rotation_speed: float = 2


func _ready() -> void:
	for i in range(initial_amount):
		var model: Node3D = item.model.instantiate()

		add_child(model)
		model.position += Vector3(0, -offset, offset) * i


func send() -> void:
	pass


func recieve() -> void:
	pass


func _process(delta: float) -> void:
	for child: Node3D in get_children():
		child.rotate(Vector3.ONE.normalized(), rotation_speed * delta)
