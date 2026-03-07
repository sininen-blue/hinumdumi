extends Node2D
class_name PetHandler

@export var wander_distance: float = 50
@export var target_node: Node

var target_pos: Vector2 = Vector2.ZERO

@onready var backup_timer: Timer = $BackupTimer


func _ready() -> void:
	target_pos = _random_distance(target_node.global_position)
	self.global_position = target_pos


func _process(_delta: float) -> void:
	if global_position.distance_to(target_node.global_position) > 200:
		target_pos = _random_distance(target_node.global_position)
		self.global_position = target_pos


func _random_distance(target: Vector2) -> Vector2:
	var rad: float = randf_range(-wander_distance, wander_distance)
	var random_vector: Vector2 = Vector2(randf_range(-rad, rad), randf_range(-rad, rad))
	var distance: Vector2 = target + random_vector
	return distance


func _on_target_collision_area_entered(_area: Area2D) -> void:
	backup_timer.start()
	
	target_pos = _random_distance(target_node.global_position)
	self.global_position = target_pos

func _on_backup_timer_timeout() -> void:
	if global_position.distance_to(target_node.global_position) < 20:
		return
	
	target_pos = _random_distance(target_node.global_position)
	self.global_position = target_pos
