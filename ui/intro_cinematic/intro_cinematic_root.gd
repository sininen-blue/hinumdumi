extends Control

@export var target: PackedScene = load("res://levels/Demo/demo_level_1.tscn")


@onready var skip_label: Label = %SkipLabel
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _input(event: InputEvent) -> void:
	if event.is_action_type():
		animation_player.stop()
		animation_player.play("fade-skip")
	
	if event.is_action_pressed("ui_cancel"):
		video_stream_player.stop()
		_on_video_stream_player_finished()


func _on_video_stream_player_finished() -> void:
	video_stream_player.stop()
	SceneManager.change_scene(target)
