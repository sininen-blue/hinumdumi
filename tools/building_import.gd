@tool
class_name BuildingImport
extends Node3D

const building_loader_path = "res://tools/building_loader/building_loader.tscn"

@export_tool_button("Generate Artifacts") var run: Callable = place
@export_file("*.blend") var model_path: String


func place():
	assert(model_path != null, "Model is empty")
	
	var parent: Node3D = get_parent()
	
	var model: PackedScene = load(model_path)
	var model_instance: Node3D = model.instantiate()
	var model_bounds: AABB = _get_aabb(model_instance)
	
	var curr_placeholder: CSGBox3D
	var curr_nav_ob: NavigationObstacle3D
	var curr_building_loader: BuildingLoader
	for child in parent.get_children():
		if child is CSGBox3D:
			curr_placeholder = child
			continue
		if child is NavigationObstacle3D:
			curr_nav_ob = child
			continue
		if child is BuildingLoader:
			curr_building_loader = child
			continue
	
	if curr_placeholder:
		parent.remove_child(curr_placeholder)
		curr_placeholder.queue_free()
	if curr_nav_ob:
		parent.remove_child(curr_nav_ob)
		curr_nav_ob.queue_free()
	if curr_building_loader:
		parent.remove_child(curr_building_loader)
		curr_building_loader.queue_free()
	
	_add_placeholder_box(model_bounds, parent)
	_add_nav_obstacle(model_bounds, parent)
	_add_building_loader(model_bounds, parent)


func _add_placeholder_box(bounds: AABB, parent: Node3D):
	var placeholder: CSGBox3D = CSGBox3D.new()
	placeholder.name = "Placeholder"
	placeholder.size = bounds.size
	placeholder.position.x = bounds.position.x + bounds.size.x / 2
	placeholder.position.z = bounds.position.z + bounds.size.z / 2
	placeholder.position.y += placeholder.size.y / 2
	parent.add_child(placeholder)
	
	placeholder.set_script(load("res://tools/placeholder.gd"))

	if Engine.is_editor_hint():
		placeholder.owner = parent


func _add_nav_obstacle(bounds: AABB, parent: Node3D):
	var nav_ob: NavigationObstacle3D = NavigationObstacle3D.new()
	nav_ob.name = "NavigationObstacle"
	
	var verts: PackedVector3Array = [
		Vector3(bounds.position.x, 0, bounds.position.z),
		Vector3(bounds.position.x, 0, bounds.position.z + bounds.size.z),
		Vector3(bounds.position.x + bounds.size.x, 0, bounds.position.z + bounds.size.z),
		Vector3(bounds.position.x + bounds.size.x, 0, bounds.position.z),
	]
	
	nav_ob.vertices = verts
	nav_ob.height = bounds.size.y
	parent.add_child(nav_ob)

	if Engine.is_editor_hint():
		nav_ob.owner = parent


func _add_building_loader(bounds: AABB, parent: Node3D):
	var loader: PackedScene = load(building_loader_path)
	var loader_instance: BuildingLoader = loader.instantiate()
	loader_instance.model_path = model_path
	
	parent.add_child(loader_instance)
	loader_instance.col_pos = Vector3(
			bounds.position.x + bounds.size.x / 2,
			bounds.size.y / 2,
			bounds.position.z + bounds.size.z / 2,
		)
	loader_instance.col_size = bounds.size
	
	if Engine.is_editor_hint():
		loader_instance.owner = parent


func _get_aabb(node: Node3D):
	var total_aabb := AABB()
	
	if node is VisualInstance3D:
		total_aabb = node.get_aabb()
		
	for child in node.get_children():
		if child is Node3D:
			var child_aabb = child.transform * _get_aabb(child)
			
			if total_aabb.size == Vector3.ZERO:
				total_aabb = child_aabb
			else:
				total_aabb = total_aabb.merge(child_aabb)
				
	return total_aabb
