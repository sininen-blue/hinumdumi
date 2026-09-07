class_name SpriteCharacter
extends Node3D

@export var idle_frame: Texture2D
@export var talk_frames: Array[Texture2D]
@export var minimum_talk_speed: float = 0.2


var current_talk_frame: int = 0


@onready var sprite: Sprite3D = %Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var talk_debounce_timer: Timer = $TalkDebounceTimer


func _ready() -> void:
	talk_debounce_timer.wait_time = minimum_talk_speed
	idle()


func idle() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector3(1.0, 1.0, 1.0), .1)
	
	sprite.texture = idle_frame
	animation_player.play("idle")


func talk() -> void:
	if talk_debounce_timer.is_stopped() != true:
		return
	
	var tween: Tween = get_tree().create_tween()
	
	tween.tween_property(sprite, "scale", Vector3(1.1, 1.1, 1.1), .1)
	sprite.texture = talk_frames[current_talk_frame]
	tween.tween_property(sprite, "scale", Vector3(1.0, 1.0, 1.0), .5)
	
	if current_talk_frame < len(talk_frames)-1:
		current_talk_frame += 1
	else:
		current_talk_frame = 0
	
	talk_debounce_timer.start()
