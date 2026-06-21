extends Node3D

class_name Home

signal finished_requirements

@export var debug: bool = false
@export var starting_cash: int = 0
@export var requirements: Dictionary[Item, int] = { }
@export var lines: Array[String] = [
	"Before dinner",
	"Can you buy me",
	"",
	"And",
	"[m]",
	"Buy the vinegar from tatoys because it's cheaper",
]

var player: Player

@onready var debug_label: Label3D = $Debug/DebugLabel
@onready var debug_model: CSGBox3D = $Debug/DebugModel


func _ready() -> void:
	debug_model.visible = false
	if not debug:
		return
	_update_debug_text()


func _update_debug_text() -> void:
	var debug_text: String = ""
	for key: Item in requirements.keys():
		debug_text += key.name + " " + str(requirements[key]) + "\n"
	debug_label.text = str(debug_text)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		PlayerStates.in_home = false

	if player == null:
		return

	for req: Item in requirements.keys():
		if req not in PlayerInventory.inventory:
			continue

		# p r  i
		# 3 4 -1
		# 4 2  2
		# 1 1  0
		var player_input: int = PlayerInventory.inventory[req] - requirements[req]
		if player_input < 0:
			requirements[req] = abs(player_input)
			for i in range(PlayerInventory.inventory[req]):
				PlayerInventory.remove_item(req)
		elif player_input > 0:
			for i in range(requirements[req]):
				PlayerInventory.remove_item(req)
			requirements[req] = 0
		else:
			requirements[req] = 0
			for i in range(PlayerInventory.inventory[req]):
				PlayerInventory.remove_item(req)

		if requirements[req] <= 0:
			requirements.erase(req)

		if requirements.is_empty():
			print("level done")
			var end: PackedScene = preload("res://src/debug/debug_death_screen.tscn")
			SceneManager.change_scene(end)
			finished_requirements.emit()

	_update_debug_text()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		PlayerStates.in_home = false
		player = null
