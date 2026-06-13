extends CharacterBody3D

class_name Monster

@export var wander_points: WanderPoints
@export var player: Player
@export var mass: float = 30


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * mass
