extends Node3D

signal found_player
signal lost_player

@export var scanning: bool = false

var vision_casts: Array[RayCast3D]
var can_see_player: bool = false:
	set = _set_can_see_player

@onready var vision_loss_timer: Timer = $VisionLossTimer
@onready var hunt: Node = %Hunt


func _ready() -> void:
	for child: Node in get_children():
		if child is RayCast3D:
			vision_casts.append(child)


func _process(_delta: float) -> void:
	if !scanning:
		return

	if can_see_player:
		# auto lock onto the player
		pass
	else:
		# start frantically moving head left to right
		pass

	can_see_player = false
	for ray in vision_casts:
		if ray.is_colliding():
			can_see_player = true
		else:
			continue

	if can_see_player == false:
		vision_loss_timer.start()


func _on_vision_loss_timer_timeout() -> void:
	lost_player.emit()


func _set_can_see_player(new_val: bool) -> void:
	if new_val != can_see_player:
		if new_val == true:
			found_player.emit()
		can_see_player = new_val
