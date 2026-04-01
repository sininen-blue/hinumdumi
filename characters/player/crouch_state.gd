extends State

@export var player: Player
@export var speed: float = 5
@export var accel: float = 1
@export var stamina_regen: float = 1.5
@export var crouch_shape: Shape3D

var previous_shape: Shape3D
var previous_y_position: float
var previous_head_height: float
var queue_uncrouch: bool = false

@onready var hide_state: State = %HideState
@onready var collision_shape: CollisionShape3D = %CollisionShape3D
@onready var head: Node3D = %Head
@onready var uncrouch_cast: RayCast3D = %UncrouchCast


func enter() -> void:
	queue_uncrouch = false
	previous_shape = collision_shape.shape
	previous_y_position = collision_shape.position.y
	previous_head_height = head.position.y
	
	collision_shape.shape = crouch_shape
	collision_shape.position.y = previous_y_position - (previous_shape.height - crouch_shape.height) / 2
	head.position.y =  (previous_shape.height - crouch_shape.height) / 2



func exit() -> void:
	collision_shape.shape = previous_shape
	collision_shape.position.y = previous_y_position
	head.position.y = previous_head_height


func update(delta: float) -> void:
	if queue_uncrouch and not uncrouch_cast.is_colliding():
		state_machine.change_state(state_machine.previous_state)
	player.current_stamina += stamina_regen * delta


func physics_update(_delta: float) -> void:
	player.current_speed = move_toward(player.current_speed, speed, accel)
	player.velocity.x = player.direction.x * player.current_speed
	player.velocity.z = player.direction.z * player.current_speed

	player.move_and_slide()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("move_crouch") and not uncrouch_cast.is_colliding():
		state_machine.change_state(state_machine.previous_state)
	elif event.is_action_released("move_crouch") and uncrouch_cast.is_colliding():
		queue_uncrouch = true
	
	if event.is_action_pressed("interact_hide"):
		state_machine.change_state(hide_state)
