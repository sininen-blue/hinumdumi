extends State

@export var player: Player
@export var speed: float = 10
@export var accel: float = 2

@onready var idle_state: Node = %IdleState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if player.input_dir == Vector2.ZERO:
		state_machine.change_state(idle_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	pass
