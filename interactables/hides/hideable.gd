extends Node3D
class_name Hideable

@export var head_position: Node3D
@export var area: Area3D


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(player: Player) -> void:
	player.can_hide = true

func _on_body_exited(player: Player) -> void:
	player.can_hide = false
