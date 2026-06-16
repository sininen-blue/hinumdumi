extends Node3D

@export var variants: Array[Node3D]


func _ready() -> void:
	for variant: Node3D in variants:
		variant.visible = false

	variants[randi_range(0, len(variants) - 1)].visible = true
