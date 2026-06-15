extends Node3D

@export var object: Node3D

var min_size: float = 0.9
var max_size: float = 1.2

var min_tilt: float = -10
var max_tilt: float = 10


func _ready() -> void:
	object.rotation_degrees = Vector3(
		randf_range(min_tilt, max_tilt),
		randf_range(-360, 360),
		randf_range(min_tilt, max_tilt),
	)
	object.scale = Vector3(
		randf_range(min_size, max_size),
		randf_range(min_size, max_size),
		randf_range(min_size, max_size),
	)
