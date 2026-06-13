extends Node3D

class_name InterestPoint

@export var debug: bool = false
@export var base_weight: float = 1
@export var weight: float = 0:
	set = _set_weight

@onready var debug_text: Label3D = $DebugText
@onready var debug_box: CSGBox3D = $DebugBox


func _ready() -> void:
	debug_box.visible = debug
	debug_text.visible = debug


func _set_weight(new_weight: float) -> void:
	weight = new_weight

	if debug:
		debug_text.text = str(weight)


func visit() -> void:
	pass
