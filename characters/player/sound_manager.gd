extends Node3D

@onready var footstep: AudioStreamPlayer3D = $Footstep
@onready var footstep_timer: Timer = $Footstep/FootstepTimer
@onready var state_machine: StateMachine = %StateMachine

@onready var walk_state: Node = %WalkState
@onready var run_state: Node = %RunState
@onready var crouch_state: Node = %CrouchState


func _process(_delta: float) -> void:
	if footstep_timer.is_stopped():
		match state_machine.current_state:
			crouch_state:
				footstep.volume_db = -25
				footstep.pitch_scale = 0.8
				footstep_timer.start(0.9)
			walk_state:
				footstep.volume_db = -15
				footstep.pitch_scale = 0.8
				footstep_timer.start(0.6)
			run_state:
				footstep.volume_db = 0
				footstep.pitch_scale = 0.6
				footstep_timer.start(0.3)


func _on_footstep_timer_timeout() -> void:
	footstep.volume_db = footstep.volume_db + randf_range(-5, 2)
	footstep.pitch_scale = footstep.pitch_scale + randf_range(-0.3, 0)
	footstep.play()
