extends Node3D

const DEBUG_POINTER = preload("uid://0oqor13sxs7t")

@export var monster: Monster


func _on_timer_timeout() -> void:
	var pointer_instance: CSGBox3D = DEBUG_POINTER.instantiate()
	add_child(pointer_instance)
	pointer_instance.global_position = monster.global_position
	pointer_instance.global_position.y += 20
