extends Node3D

class_name Hand

@export var holding_offset_y: float = 0.25
@export var holding_offset_x: float = 0.10

var holding: Dictionary[Item, Array] = { }
var total_items: int = 0


func add_item(item: Item) -> void:
	randomize()
	var model: Node3D = item.model.instantiate()

	var x_offset: float = randf_range(-holding_offset_x, holding_offset_x)
	var y_offset: float = holding_offset_y * total_items
	var z_offset: float = randf_range(-holding_offset_x, holding_offset_x)

	if holding.has(item):
		holding[item].append(model)
	else:
		holding[item] = [model]

	total_items += 1
	model.scale = Vector3.ZERO
	self.add_child(model)
	var target_pos: Vector3 = model.position + Vector3(x_offset, y_offset, z_offset)

	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(model, "scale", Vector3.ONE, 1.25)
	tween.tween_property(model, "position", target_pos, 1.25)


# returns true if item is successfully removed
func remove_item(item: Item) -> void:
	randomize()

	if holding.has(item) == false:
		printerr(item.name, " does not exist on ", self.name)
		return

	var model: Node3D = holding[item].pop_back()
	if holding[item].is_empty():
		holding.erase(item)
	total_items -= 1

	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(model, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(model.queue_free)
	await model.tree_exited
	_arrange_items()


func has_item(item: Item) -> bool:
	if holding.has(item):
		return true
	return false


func _arrange_items() -> void:
	var index: int = 0
	for child: Node3D in get_children():
		var y_offset: float = holding_offset_y * index
		var start_position: Vector3 = Vector3(child.position.x, 0, child.position.z)
		var target: Vector3 = start_position + Vector3(child.position.x, y_offset, child.position.z)

		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(child, "position", target, 1.2)
		tween.play()

		index += 1
