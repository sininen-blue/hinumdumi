extends State

@export var player: Player
@export var speed: float = 5
@export var accel: float = 1
@export var stamina_regen: float = 1.5
@export var crouch_shape: Shape3D

var previous_shape: Shape3D
var previous_height: float

@onready var hide_state: State = %HideState
@onready var collision_shape: CollisionShape3D = %CollisionShape3D


func enter() -> void:
	previous_shape = collision_shape.shape
	previous_height = collision_shape.position.y
	
	collision_shape.shape = crouch_shape
	collision_shape.position.y = crouch_shape.height



func exit() -> void:
	collision_shape.shape = previous_shape
	collision_shape.position.y = previous_height


func update(delta: float) -> void:
	player.current_stamina += stamina_regen * delta


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("move_crouch"):
		state_machine.change_state(state_machine.previous_state)
	if event.is_action_pressed("interact_hide"):
		state_machine.change_state(hide_state)
