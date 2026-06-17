extends Node3D

@onready var tree_3d: Tree3D = $Tree3D

var min_size: float = 0.9
var max_size: float = 1.4

var min_tilt: float = -10
var max_tilt: float = 10


func _ready() -> void:
	tree_3d.seed = randi_range(0, 1000)

	tree_3d.rotation_degrees = Vector3(
		randf_range(min_tilt, max_tilt),
		randf_range(-360, 360),
		randf_range(min_tilt, max_tilt),
	)
