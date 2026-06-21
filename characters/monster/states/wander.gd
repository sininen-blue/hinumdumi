extends State

@export var monster: Monster
@export var nav: NavigationAgent3D
@export var speed: float = 2
@export var distance_threhold: float = 100

var player: Player
var interest_points: Array[InterestPoint] = []
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var scanning: State = %Scanning
@onready var hunt: Node = %Hunt
@onready var investigate: Node = %Investigate

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	interest_points = monster.wander_points.points


func enter() -> void:
	nav.target_position = _get_target_point()
	animation_player.play("Lando Walk/Armature|mixamo_com|Layer0")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if PlayerStates.left_home == false or PlayerStates.first_buy == false:
		return
	if monster.started == false: # NOTE: ugly, change this at some point
		monster.started = true

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

		var noise: float = randf_range(0, 0.2)
		point.weight = normalized * point.base_weight * noise

		if distance < 5:
			point.weight = 0
		if point.global_position.distance_to(monster.player.global_position) > distance_threhold:
			point.weight = 0

		if point.weight > candidate.weight:
			candidate = point

	candidate.visit()
	return candidate.global_position


func _on_monster_navigation_agent_navigation_finished() -> void:
	state_machine.change_state(scanning)


func detect_player(noise: int) -> void:
	if noise >= 3:
		state_machine.last_known_position = monster.player.global_position
		state_machine.change_state(investigate)
