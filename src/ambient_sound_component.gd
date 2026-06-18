extends Node3D

var sounds: Array[AudioStreamPlayer3D]
@onready var timer: Timer = $Timer

var is_playing: bool = false
var current_player: AudioStreamPlayer3D


func _ready() -> void:
	for child: Variant in get_children():
		if child is AudioStreamPlayer3D:
			sounds.append(child)

	timer.start(randf_range(5, 70))


func _on_timer_timeout() -> void:
	current_player = sounds.pick_random()
	current_player.play()
	current_player.finished.connect(_on_sound_finished)


func _on_sound_finished() -> void:
	current_player.finished.disconnect(_on_sound_finished)
	timer.start(randf_range(20, 40))
