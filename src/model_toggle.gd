extends Node3D

@export var open_model: Node3D
@export var close_model: Node3D
@export var open: bool = true


func _ready() -> void:
	open_model.visible = open
	close_model.visible = !open
