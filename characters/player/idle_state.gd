extends State

@export var player: Player 
@export var decel: float = 1
@export var stamina_regen: float = 1
@export var stamina_run_threshold: float = 1

@onready var idle_state: State = %IdleState
@onready var crouch_state: State = %CrouchState
@onready var jump_state: State = %JumpState
@onready var run_state: State = %RunState
@onready var walk_state: State = %WalkState
@onready var hide_state: State = %HideState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	player.current_stamina += stamina_regen * delta
	
	if player.direction != Vector3.ZERO:
		state_machine.change_state(walk_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, 0, decel)

	player.velocity.x = player.prev_dir.x * player.current_speed
	player.velocity.z = player.prev_dir.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump") and player.is_on_ground:
		state_machine.change_state(jump_state)
	if event.is_action_pressed("move_crouch") and player.is_on_ground:
		state_machine.change_state(crouch_state)
	if event.is_action_pressed("move_run") and player.current_stamina > stamina_run_threshold:
		state_machine.change_state(run_state)
	if event.is_action_pressed("interact_hide"):
		state_machine.change_state(hide_state)
