extends State

@export var monster: Monster
@export var lunge_force: float

var direction: Vector3 = Vector3.ZERO

@onready var lunge_cooldown: Timer = $LungeCooldown
@onready var hunt: Node = %Hunt


func enter() -> void:
	lunge_cooldown.start()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func lunge_finished() -> void:
	state_machine.change_state(hunt)
