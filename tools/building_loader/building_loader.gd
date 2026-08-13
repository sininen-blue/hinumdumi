@tool
extends Node3D
class_name BuildingLoader

@export var model_path: String
@export var col_size: Vector3
@export var col_pos: Vector3


func _ready() -> void:
	$LoadArea/CollisionShape3D.shape.size = col_size
	$LoadArea/CollisionShape3D.position = col_pos


func _on_load_area_area_entered(_area: Area3D) -> void:
	if ResourceLoader.exists(model_path):
		var level_resource: PackedScene = ResourceLoader.load(model_path)
		var level_instance: Node3D = level_resource.instantiate()
		get_parent().add_child(level_instance)
