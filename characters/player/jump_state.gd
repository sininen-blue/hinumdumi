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

@onready var ground_cast_toggle_timer: Timer = $GroundCastToggleTimer


func enter() -> void:
	player.current_stamina -= stamina_cost
	
	player.ground_cast.enabled = false
	ground_cast_toggle_timer.start()
	
	
	player.velocity.y += jump_force


func exit() -> void:
	pass


func update(_delta: float) -> void:
	print(player.is_on_ground)
	if player.is_on_ground:
		state_machine.change_state(state_machine.previous_state)


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(_event: InputEvent) -> void:
	pass


func _on_ground_cast_toggle_timer_timeout() -> void:
	player.ground_cast.enabled = true
