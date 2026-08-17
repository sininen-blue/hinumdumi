extends Node3D

@export var debug: bool = true

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_timer_timeout() -> void:
	if debug:
		animation_player.play("turn-off")
		return
	
	if randi_range(0, 3) == 0:
		animation_player.play("turn-off")
	else:
		animation_player.play("flicker")


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	if debug:
		timer.start(1)
		return
	
	if randi_range(0, 3) == 0:
		timer.start(randf_range(1, 4))
