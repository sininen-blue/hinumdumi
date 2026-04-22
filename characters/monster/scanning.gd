extends State

@export var monster: Monster
@onready var scan_timer: Timer = $ScanTimer

@onready var wander: Node = %Wander


func enter() -> void:
	scan_timer.start()


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func _on_scan_timer_timeout() -> void:
	state_machine.change_state(wander)
