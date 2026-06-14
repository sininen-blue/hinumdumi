extends CharacterBody3D

class_name Monster

@export var wander_points: WanderPoints
@export var player: Player
@export var mass: float = 30


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * mass


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		SceneManager.change_scene(load("res://src/debug/debug_death_screen.tscn"))
