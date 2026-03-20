extends State

@export var player: Player 
@export var decel: float = 1

@onready var walk_state: State = %WalkState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if player.direction != Vector3.ZERO:
		state_machine.change_state(walk_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, 0, decel)

	player.velocity.x = player.prev_dir.x * player.current_speed
	player.velocity.z = player.prev_dir.z * player.current_speed

	player.move_and_slide()


func handle_input(_event: InputEvent) -> void:
	pass
