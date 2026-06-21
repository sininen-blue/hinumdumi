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

	if current_player.playing:
		timer.start(randf_range(20, 40))
		return

	current_player.play()
	timer.start(randf_range(20, 40))
