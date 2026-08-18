@tool
extends Node3D

@export_file("*.blend", "*.gltf", "*.glb") var model_path: String:
	set(value):
		model_path = value
		_refresh_preview()

var _preview_instance: Node3D

func _ready() -> void:
	if not Engine.is_editor_hint():
		visible = false  # runtime: BuildingLoader owns rendering, hide ourselves
		return
	_refresh_preview()

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	if model_path.is_empty():
		return

	var viewport := EditorInterface.get_editor_viewport_3d(0)
	# If the 3D tab isn't active the frustum is meaningless — leave state alone.
	if not viewport.get_parent().is_visible_in_tree():
		return

	var camera := viewport.get_camera_3d()
	if camera == null:
		return

	var in_view := camera.is_position_in_frustum(global_position)

	if in_view and _preview_instance == null:
		_refresh_preview()
	elif not in_view and _preview_instance != null:
		_clear_preview()

func _refresh_preview() -> void:
	_clear_preview()

	if not Engine.is_editor_hint():
		return
	if not is_inside_tree():
		return
	if model_path.is_empty():
		return

	var scene: PackedScene = load(model_path)
	if scene == null:
		push_warning("Placeholder: failed to load model at '%s'" % model_path)
		return

	_preview_instance = scene.instantiate()
	_preview_instance.name = "EditorPreview"
	_preview_instance.position = -position
	add_child(_preview_instance)
	# No .owner assignment -> never written to the .tscn file.

func _clear_preview() -> void:
	if _preview_instance and is_instance_valid(_preview_instance):
		_preview_instance.queue_free()
	_preview_instance = null

func _exit_tree() -> void:
	_clear_preview()
