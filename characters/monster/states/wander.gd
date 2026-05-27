extends State

@export var monster: Monster
@export var nav: NavigationAgent3D
@export var speed: float = 2

var player: Player
var interest_points: Array[InterestPoint] = []
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var scanning: State = %Scanning
@onready var hunt: Node = %Hunt
@onready var investigate: Node = %Investigate


func _ready() -> void:
	interest_points = monster.wander_points.points


func enter() -> void:
	nav.target_position = _get_target_point()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	next_path_position = nav.get_next_path_position()
	direction = monster.global_position.direction_to(next_path_position)
	monster.velocity = direction * speed
	monster.move_and_slide()


# target distance should be ranked based to encourage moving in between large distances
# current system makes monster too likely to hole up in an area
# can be worked around by placing points evenly across the map
# but a better system would work better
func _get_target_point() -> Vector3:
	if interest_points.is_empty():
		printerr("Interest Points is Empty")
		return monster.global_position

	var monster_pos: Vector3 = monster.global_position
	var farthest_point: InterestPoint = interest_points[0]
	var closest_point: InterestPoint = interest_points[0]

	for point: InterestPoint in interest_points:
		var far_distance: float = monster_pos.distance_squared_to(farthest_point.global_position)
		var close_distance: float = monster_pos.distance_squared_to(closest_point.global_position)
		var new_distance: float = monster_pos.distance_squared_to(point.global_position)

		if new_distance > far_distance:
			farthest_point = point
		if new_distance < close_distance:
			closest_point = point

	var farthest_distance: float = monster_pos.distance_squared_to(farthest_point.global_position)
	var closest_distance: float = monster_pos.distance_squared_to(closest_point.global_position)
	var distance_range: float = farthest_distance - closest_distance

	var candidate: InterestPoint = closest_point
	for point: InterestPoint in interest_points:
		var distance: float = monster_pos.distance_squared_to(point.global_position)
		var normalized: float = (distance - closest_distance) / distance_range
		normalized = 1 - normalized
		var noise: float = randf_range(0, 0.01)

		point.weight = normalized * noise * point.base_weight
		if distance < 5:
			point.weight = 0

		if point.weight > candidate.weight:
			candidate = point

	candidate.visit()
	return candidate.global_position


func _on_monster_navigation_agent_navigation_finished() -> void:
	state_machine.change_state(scanning)


func _on_head_found_player() -> void:
	state_machine.change_state(hunt)


func _on_hearing_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		player.noise_created.connect(_on_player_noise_created)


func _on_hearing_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player.noise_created.disconnect(_on_player_noise_created)
		player = null


func _on_player_noise_created(noise_level: float) -> void:
	if noise_level > 3: # TODO: temp value
		state_machine.last_known_position = player.global_position
		state_machine.change_state(investigate)
