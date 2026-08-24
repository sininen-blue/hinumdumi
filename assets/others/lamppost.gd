extends Node3D
class_name Lamppost

@onready var animation_player: AnimationPlayer = $AnimationPlayer

	
func off():
	animation_player.play("turn-off")


func flicker():
	animation_player.play("flicker")
