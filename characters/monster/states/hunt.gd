extends State

@export var monster: Monster
@export var nav: NavigationAgent3D

@export var speed: float = 3.0

var player: Player
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var investigate: Node = %Investigate


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	if player:
		nav.target_position = player.position


func physics_update(delta: float) -> void:
	next_path_position = nav.get_next_path_position()
	direction = monster.global_position.direction_to(next_path_position)
	monster.velocity = direction * speed
	monster.move_and_slide()


func _on_head_lost_player() -> void:
	state_machine.change_state(investigate)
