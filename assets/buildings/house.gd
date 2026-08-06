extends Node3D

@onready var inside_mark: Marker3D = $InsidePosition
@onready var outside_mark: Marker3D = $OutsidePosition

@onready var enter_label: Label3D = $EnterLabel
@onready var exit_label: Label3D = $ExitLabel

@onready var exit_area: Area3D = $ExitArea
@onready var enter_area: Area3D = $EnterArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player
var is_inside: bool = true


func _ready() -> void:
	enter_label.visible = false
	exit_label.visible = false


func _input(event: InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("interact"):
		animation_player.play("blink")


func _trigger_teleport() -> void:
	if is_inside:
		player.global_position = outside_mark.global_position
	else:
		player.global_position = inside_mark.global_position
	_trigger_resync()


func _trigger_resync() -> void:
	exit_area.monitoring = false
	enter_area.monitoring = false
	
	exit_area.monitoring = true
	enter_area.monitoring = true


func _on_exit_area_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	exit_label.visible = true
	is_inside = true
	player = body


func _on_exit_area_body_exited(body: Node3D) -> void:
	if body is not Player:
		return
	exit_label.visible = false
	is_inside = false
	player = null


func _on_enter_area_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	enter_label.visible = true
	is_inside = false
	player = body


func _on_enter_area_body_exited(body: Node3D) -> void:
	if body is not Player:
		return
	enter_label.visible = false
	is_inside = true
	player = null
