extends State

@export var player: Player
@export var speed: float = 10
@export var accel: float = 2
@export var stamina_regen: float = 0.5
@export var stamina_run_threshold: float = 1
@export var headbob_frequency: float = 3
@export var headbob_strength: float = 0.05

var headbob_time: float = 0 

@onready var idle_state: State = %IdleState
@onready var crouch_state: State = %CrouchState
@onready var jump_state: State = %JumpState
@onready var run_state: State = %RunState
@onready var hide_state: State = %HideState

@onready var camera_3d: Camera3D = %Camera3D



func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	headbob_time += player.velocity.length() * float(player.is_on_ground) * delta
	var target: Vector3 = state_machine.headbob(headbob_time, headbob_frequency, headbob_strength)
	camera_3d.transform.origin = camera_3d.transform.origin.move_toward(target, 0.01)
	
	player.current_stamina += stamina_regen * delta
	if player.input_dir == Vector2.ZERO:
		state_machine.change_state(idle_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

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
