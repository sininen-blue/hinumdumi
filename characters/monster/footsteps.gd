extends AudioStreamPlayer3D

const FOOTSTEPS_HEAVY_1 = preload("uid://bno8umd8dkv0")
const FOOTSTEPS_HEAVY_2 = preload("uid://dj40u88cffuiv")
const FOOTSTEPS_HEAVY_3 = preload("uid://c15mfp1t23tiv")
const FOOTSTEPS_HEAVY_4 = preload("uid://dqww8xsdsp3df")

@export var state_machine: StateMachine

var footsteps = [
	FOOTSTEPS_HEAVY_1,
	FOOTSTEPS_HEAVY_2,
	FOOTSTEPS_HEAVY_3,
	FOOTSTEPS_HEAVY_4,
]

@onready var timer: Timer = %FootstepTimer
@onready var wander: Node = %Wander
@onready var scanning: Node = %Scanning
@onready var investigate: Node = %Investigate
@onready var hunt: Node = %Hunt


func _on_state_machine_changed_state(state: State) -> void:
	match state:
		wander:
			timer.wait_time = 1.5
		scanning:
			timer.wait_time = 3
		investigate:
			timer.wait_time = 0.7
		hunt:
			timer.wait_time = 0.3


func _on_timer_timeout() -> void:
	var random_footstep = footsteps.pick_random()
	self.stream = random_footstep
	self.play()

	timer.start()
