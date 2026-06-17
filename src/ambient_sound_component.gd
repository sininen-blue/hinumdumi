extends Node3D

var sounds: Array[AudioStreamPlayer3D]
@onready var timer: Timer = $Timer


func _ready() -> void:
	for child: Variant in get_children():
		if child is AudioStreamPlayer3D:
			sounds.append(child)

	timer.start(randf_range(5, 40))


func _on_timer_timeout() -> void:
	sounds.pick_random().play()
