extends CharacterBody3D

class_name Monster

@export var wander_points: WanderPoints
@export var player: Player
@export var mass: float = 30
@onready var state_machine: StateMachine = $StateMachine

@onready var footstep_timer: Timer = %FootstepTimer # NOTE: make an actual sound manager
@onready var lando: Node3D = $Lando
@onready var jumpscare: Node = %Jumpscare

var started = false:
	set(new_val):
		started = new_val

		if new_val == true:
			footstep_timer.start()


## NOTE: override once close eonugh to the player
func _physics_process(delta: float) -> void:
	var target_pos: Vector3 = Vector3.ZERO
	if state_machine.current_state == jumpscare:
		target_pos = global_position.direction_to(player.global_position)
		var target_trans = transform.looking_at(target_pos, Vector3.UP)
		transform.basis = transform.basis.slerp(target_trans.basis, 5 * delta)
	else:
		if velocity != Vector3.ZERO:
			target_pos = global_position + -velocity
		var target_trans = transform.looking_at(target_pos, Vector3.UP)
		transform.basis = transform.basis.slerp(target_trans.basis, 5 * delta)
