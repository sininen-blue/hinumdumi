extends Area3D

class_name InteractArea

func _ready() -> void:
	self.set_collision_mask_value(1, false)
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(3, true)


func interact() -> void:
	get_parent().interact()
