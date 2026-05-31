extends Node3D

signal finished_requirements

@export var debug: bool = false
@export var requirements: Dictionary[Item, int] = { }

var player: Player

@onready var debug_label: Label3D = $Debug/DebugLabel


func _ready() -> void:
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
			finished_requirements.emit()

	_update_debug_text()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
