extends State

@export var monster: Monster
@export var nav: NavigationAgent3D

@export var speed: float = 3.0

var suspicion: int = 0
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var wander: Node = %Wander
@onready var scanning: Node = %Scanning
@onready var hunt: Node = %Hunt
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func enter() -> void:
	animation_player.speed_scale = 1.2
	animation_player.play("Lando Walk/Armature|mixamo_com|Layer0")
	nav.target_position = state_machine.last_known_position


func exit() -> void:
	animation_player.speed_scale = 1


func update(_delta: float) -> void:
	if PlayerStates.in_home == true:
		state_machine.change_state(wander)


func physics_update(_delta: float) -> void:
	next_path_position = nav.get_next_path_position()
	direction = monster.global_position.direction_to(next_path_position)
	monster.velocity = direction * speed
	monster.move_and_slide()


func _on_monster_navigation_agent_navigation_finished() -> void:
	state_machine.change_state(scanning)


func detect_player(noise: int) -> void:
	if noise >= 1:
		state_machine.change_state(hunt)
