extends State

@export var monster: Monster
@onready var scan_timer: Timer = $ScanTimer

var player: Player

@onready var wander: Node = %Wander
@onready var investigate: Node = %Investigate
@onready var hunt: Node = %Hunt


func enter() -> void:
	scan_timer.start()


func exit() -> void:
	scan_timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_scan_timer_timeout() -> void:
	state_machine.change_state(wander)


func detect_player(noise: int) -> void:
	if noise >= 2:
		state_machine.change_state(investigate)
