extends State

@export var monster: Monster
@export var nav: NavigationAgent3D

@export var speed: float = 3.0

var suspicion: int = 0
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var scanning: Node = %Scanning
@onready var hunt: Node = %Hunt


func enter() -> void:
	nav.target_position = state_machine.last_known_position


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	next_path_position = nav.get_next_path_position()
	direction = monster.global_position.direction_to(next_path_position)
	monster.velocity = direction * speed
	monster.move_and_slide()


func _on_monster_navigation_agent_navigation_finished() -> void:
	state_machine.change_state(scanning)


func _on_head_found_player() -> void:
	state_machine.change_state(hunt)
