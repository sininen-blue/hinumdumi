extends State

@export var player: Player
@export var speed: float = 40
@export var hover_force: float = 60
@export var accel: float = 40

@onready var debug_flight_timer: Timer = $DebugFlightTimer
@onready var collision_shape: CollisionShape3D = %CollisionShape3D


func enter() -> void:
	player.current_stamina = player.max_stamina
	
	player.enabled_gravity = false
	collision_shape.disabled = true


func exit() -> void:
	player.enabled_gravity = true
	collision_shape.disabled = false


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed
	
	if Input.is_action_pressed("move_jump"):
		player.velocity.y += hover_force * delta
	elif Input.is_action_pressed("move_crouch"):
		player.velocity.y -= hover_force * delta
	else:
		player.velocity.y = 0
	
	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump") and !debug_flight_timer.is_stopped():
		state_machine.change_state(state_machine.previous_state)
	if event.is_action_pressed("move_jump"):
		debug_flight_timer.start()
