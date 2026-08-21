extends PlayerEvent
class_name SoundPlayerEvent

@export var sound: AudioStream


@onready var sound_player: AudioStreamPlayer3D = $SoundPlayer


func _ready() -> void:
	super._ready()
	sound_player.stream = sound


func run_event(_player: Player) -> void:
	if sound_player.playing:
		return
	
	sound_player.play()
