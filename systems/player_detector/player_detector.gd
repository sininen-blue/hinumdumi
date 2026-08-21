extends Area3D
class_name PlayerDetector

signal detected_player(player: Player)


func _ready() -> void:
	self.set_collision_layer_value(1, false)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, true)
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	detected_player.emit(body)
