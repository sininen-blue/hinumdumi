extends Node3D

@export var play_level: PackedScene = preload("res://levels/Demo/demo_level_1.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	animation_player.play("camera_bob")
	audio_stream_player.play()


func _on_play_button_pressed() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, 'volume_db', -40, 1)
	await tween.finished
	SceneManager.change_scene(play_level)
