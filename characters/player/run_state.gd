extends State

@export var player: Player 
@export var speed: float = 15
@export var accel: float = 2
@export var stamina_cost: float = 1

@onready var idle_state: State = %IdleState
@onready var crouch_state: State = %CrouchState
@onready var jump_state: State = %JumpState
@onready var hide_state: State = %HideState


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	player.current_stamina -= stamina_cost * delta
	
	if player.current_stamina <= 0:
		state_machine.change_state(state_machine.previous_state)
	if player.input_dir == Vector2.ZERO:
		state_machine.change_state(idle_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump") and player.is_on_floor():
		state_machine.change_state(jump_state)
	if event.is_action_pressed("move_crouch") and player.is_on_floor():
		state_machine.change_state(crouch_state)
	if event.is_action_pressed("interact_hide"):
		state_machine.change_state(hide_state)
