extends State

@export var monster: Monster
@export var nav: NavigationAgent3D
@export var speed: float = 300

var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var points: Array[Node3D] = monster.wander_points
@onready var scanning: State = %Scanning


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


func _get_target_point() -> Vector3:
	return Vector3.ZERO


func _on_monster_navigation_agent_navigation_finished() -> void:
	state_machine.change_state(scanning)
