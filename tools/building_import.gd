@tool
class_name BuildingImport
extends Node3D

@export_tool_button("Generate Artifacts") var run: Callable = place
@export_file("*.blend", "*.gltf", "*.glb") var model_path: String

func place():
	assert(model_path != null, "Model is empty")

	var parent: Node3D = get_parent()

	var model: PackedScene = load(model_path)
	var model_instance: Node3D = model.instantiate()

	var aabb_result: Dictionary = _get_aabb(model_instance)

	if not aabb_result.has_content:
		push_error("BuildingImport: no visual geometry found in '%s'" % model_path)
		return
	var model_bounds: AABB = aabb_result.aabb

	var curr_nav_ob: NavigationObstacle3D
	for child in parent.get_children():
		if child is NavigationObstacle3D:
			curr_nav_ob = child
			continue
	if curr_nav_ob:
		parent.remove_child(curr_nav_ob)
		curr_nav_ob.queue_free()
	_add_nav_obstacle(model_bounds, parent)
	
	model_instance.name = "Model"
	parent.add_child(model_instance)
	if Engine.is_editor_hint():
		model_instance.owner = parent
	
	self.queue_free()


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
	nav_ob.position.y = bounds.position.y
	parent.add_child(nav_ob)
	if Engine.is_editor_hint():
		nav_ob.owner = parent


func _get_aabb(node: Node3D) -> Dictionary:
	var result_aabb := AABB()
	var has_content := false

	if node is VisualInstance3D:
		result_aabb = node.get_aabb()
		has_content = true

	for child in node.get_children():
		if child is Node3D:
			var child_result: Dictionary = _get_aabb(child)
			if not child_result.has_content:
				continue # empty/bone/camera/light

			var child_aabb: AABB = child.transform * child_result.aabb
			if not has_content:
				result_aabb = child_aabb
			else:
				result_aabb = result_aabb.merge(child_aabb)
			has_content = true

	return {"aabb": result_aabb, "has_content": has_content}
