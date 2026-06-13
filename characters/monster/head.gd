extends Node3D

@export var scanning: bool = false

var vision_casts: Array[RayCast3D]

@onready var vision_loss_timer: Timer = $VisionLossTimer
@onready var player: Player = self.get_parent().player
@onready var hunt: Node = %Hunt


func _ready() -> void:
	for child: Node in get_children():
		if child is RayCast3D:
			vision_casts.append(child)


func _process(delta: float) -> void:
	self.look_at(self.global_position.direction_to(player.global_position))
