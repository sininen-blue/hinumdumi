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
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func _on_scan_timer_timeout() -> void:
	state_machine.change_state(wander)


func _on_hearing_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		player.noise_created.connect(_on_player_noise_created)


func _on_hearing_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player.noise_created.disconnect(_on_player_noise_created)
		player = null


func _on_player_noise_created(noise_level: float) -> void:
	if noise_level > 3: # TODO: temp value
		state_machine.change_state(investigate)


func _on_head_found_player() -> void:
	state_machine.change_state(hunt)
