extends State

@export var monster: Monster

@onready var swipe_cooldown: Timer = $SwipeCooldown
@onready var hunt: Node = %Hunt


func enter() -> void:
	swipe_cooldown.start()


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func swipe_finished() -> void:
	state_machine.change_state(hunt)
