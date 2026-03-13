extends Control

@onready var scene_1: TextureRect = $Scene1
@onready var scene_2: TextureRect = $Scene2
@onready var scene_3: TextureRect = $Scene3
@onready var scene_4: Sprite2D = $Scene4

func _ready() -> void:
	State.scene_1 = scene_1
	State.scene_2 = scene_2
	State.scene_3 = scene_3
	State.scene_4 = scene_4
