extends State

@export var monster: Monster


func enter() -> void:
	state_machine.toggle_lock()
	var player: Player = monster.player
	player.start_jumpscare(monster)

	# loook at player and pause
	# pull player camera to me
	# then trigger the player jumpscare


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass
