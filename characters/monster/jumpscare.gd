extends State

@export var monster: Monster
@onready var footstep_timer: Timer = %FootstepTimer


func enter() -> void:
	footstep_timer.stop()
	state_machine.toggle_lock()
	var player: Player = monster.player
	player.start_jumpscare(monster)

	# loook at player and pause
	# pull player camera to me
	# then trigger the player jumpscare


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
