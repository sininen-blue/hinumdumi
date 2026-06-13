extends Area3D

var player: Player

@onready var investigate: Node = %Investigate
@onready var state_machine: StateMachine = $"../StateMachine"


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		player.noise_created.connect(_on_player_noise_created)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player.noise_created.disconnect(_on_player_noise_created)
		player = null


func _on_player_noise_created(noise_level: float) -> void:
	if state_machine.current_state == investigate:
		investigate.detect_player(noise_level)
