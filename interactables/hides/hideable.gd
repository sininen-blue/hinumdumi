class_name Hideable
extends Node3D

var player: Player

@onready var exit_area: Node3D = $ExitArea
@onready var debug_box: CSGBox3D = $ExitArea/DebugBox


func _ready() -> void:
	debug_box.visible = false


func _on_hide_area_body_entered(body: Node3D) -> void:
	if body is Player:
		body.can_hide = true
		body.hideable = self


func _on_hide_area_body_exited(body: Node3D) -> void:
	if body is Player:
		body.can_hide = false
		body.hideable = null
