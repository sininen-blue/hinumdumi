extends Node3D

class_name Hand

@export var holding: Array[Item] = []
@export var holding_offset_y: float = 0.25
@export var holding_offset_x: float = 0.10


func add_item(item: Item) -> void:
	randomize()
	var model: Node3D = item.model.instantiate()

	var x_offset: float = randf_range(-holding_offset_x, holding_offset_x)
	var y_offset: float = randf_range(holding_offset_y * .75, holding_offset_y) * holding.size()
	var z_offset: float = randf_range(-holding_offset_x, holding_offset_x)

	holding.append(item)
	self.add_child(model)
	model.global_position += Vector3(x_offset, y_offset, z_offset)
