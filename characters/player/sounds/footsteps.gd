extends AudioStreamPlayer3D

@export var player: Player
@export var sounds: Array[AudioStream]
@export var default_db: float = -17.5

var interval: float = 1.0
var buildup: float = 0.0
var current_sound: int = 0
var current_db: float = default_db
var current_noise_level: Constants.noise_levels

@onready var sound_player_pool_1: AudioStreamPlayer3D = $SoundPlayerPool1
@onready var sound_player_pool_2: AudioStreamPlayer3D = $SoundPlayerPool2
@onready var sound_player_pool_3: AudioStreamPlayer3D = $SoundPlayerPool3
@onready var sound_player_pool_4: AudioStreamPlayer3D = $SoundPlayerPool4
@onready var sound_player_pool_5: AudioStreamPlayer3D = $SoundPlayerPool5
@onready var sound_players: Array[AudioStreamPlayer3D] = [
	self,
	sound_player_pool_1,
	sound_player_pool_2,
	sound_player_pool_3,
	sound_player_pool_4,
	sound_player_pool_5,
]

@onready var state_machine: StateMachine = %StateMachine
@onready var walk_state: Node = %WalkState
@onready var run_state: Node = %RunState
@onready var crouch_state: Node = %CrouchState


func _process(delta: float) -> void:
	match state_machine.current_state:
		walk_state:
			interval = 0.6
			current_db = default_db
			current_noise_level = Constants.noise_levels.LOW
		run_state:
			interval = 0.3
			current_db = default_db + 2
			current_noise_level = Constants.noise_levels.MEDIUM
		crouch_state:
			interval = 0.8
			current_db = default_db - 10
			current_noise_level = Constants.noise_levels.NONE
	
	if player.velocity != Vector3.ZERO and player.is_on_ground:
		buildup += 1 * delta
	else:
		buildup = 0
	
	if buildup >= interval:
		buildup = 0
		var sound: AudioStream = sounds[current_sound]
		
		for sound_player in sound_players:
			if sound_player.playing == false:
				sound_player.stream = sound
				sound_player.pitch_scale = randf_range(0.9, 1.1)
				sound_player.volume_db = randf_range(current_db-1, current_db+1)
				sound_player.play()
				
				player.noise_created.emit(current_noise_level)
				break
		
		current_sound += 1
		if current_sound >= len(sounds):
			current_sound = 0
