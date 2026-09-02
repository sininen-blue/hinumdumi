extends Node3D

@export var level_target: PackedScene = preload("res://ui/disclaimer/disclaimer.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pause_root: Control = $MainMenuLayer/PauseRoot


func _ready() -> void:
	animation_player.play("camera_bob")
	audio_stream_player.play()


func _on_play_button_pressed() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, 'volume_db', -40, 1)
	await tween.finished
	SceneManager.change_scene(level_target)


func _on_settings_button_pressed() -> void:
	pause_root.show_settings()
