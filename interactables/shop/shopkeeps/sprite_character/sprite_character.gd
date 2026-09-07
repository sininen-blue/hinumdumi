class_name SpriteCharacter
extends Node3D

@export var idle_frame: Texture2D
@export var talk_frames: Array[Texture2D]

@onready var sprite: Sprite3D = %Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	idle()


func idle() -> void:
	sprite.texture = idle_frame
	animation_player.play("idle")


func talk() -> void:
	sprite.texture = talk_frames[0]
