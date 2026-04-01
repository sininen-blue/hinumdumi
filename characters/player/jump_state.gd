extends State

@export var player: Player
@export var speed: float = 10
@export var accel: float = 0.5
@export var jump_force: float = 15
@export var stamina_cost: float = 2

@onready var idle_state: State = %IdleState
@onready var crouch_state: State = %CrouchState
@onready var jump_state: State = %JumpState
@onready var run_state: State = %RunState
@onready var hide_state: State = %HideState
@onready var debug_flight_state: Node = %DebugFlightState

@onready var ground_cast_toggle_timer: Timer = $GroundCastToggleTimer
@onready var debug_flight_timer: Timer = $DebugFlightTimer


func enter() -> void:
	player.current_stamina -= stamina_cost
	
	player.ground_cast.enabled = false
	ground_cast_toggle_timer.start()
	debug_flight_timer.start()
	
	player.velocity.y += jump_force


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if player.is_on_ground:
		state_machine.change_state(idle_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump") and !debug_flight_timer.is_stopped():
		state_machine.change_state(debug_flight_state)


func _on_ground_cast_toggle_timer_timeout() -> void:
	player.ground_cast.enabled = true
