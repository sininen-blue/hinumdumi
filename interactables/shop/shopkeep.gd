extends Node3D

class_name Shop

@export var shoppableItem: PackedScene
@export var inventory: Dictionary[Item, int]
@export var cost_modifier: float = 1
@export var shoppable_offset: float = 2

@export var intro_lines: Array[String] = [
	"What are you buying?",
]
@export var outro_line: Array[String] = [
	"Okay",
]

var player: Player

@onready var dialogue_component: DialogueComponent = $DialogueComponent
@onready var item_interacts: ItemInteracts = $ItemInteracts


func _on_item_interact(item: Item) -> void:
	if PlayerInventory.money >= item.base_cost:
		var stock: int = inventory.get(item, 0)
		if stock <= 0:
			return

		if PlayerStates.first_buy == false:
			PlayerStates.first_buy = true
		PlayerInventory.money -= item.base_cost
		inventory[item] -= 1
		item.origin = self
		var hand: Hand = PlayerInventory.add_item(item)
		item_interacts.send(item, hand)


func _on_return_interact(item: Item) -> void:
	for player_item: Item in PlayerInventory.inventory.keys():
		if player_item != item:
			continue

		if item.origin == self:
			var hand: Hand = PlayerInventory.remove_item(item)
			item_interacts.recieve(item, hand)
			PlayerInventory.money += item.base_cost
			inventory[item] += 1


func _on_shoppable_area_body_entered(body: Node3D) -> void:
	if body is Player:
		self.player = body

		dialogue_component.add_line("what are you buying?")
		dialogue_component.start_talking()


func _on_shoppable_area_body_exited(body: Node3D) -> void:
	if body is Player:
		self.player = null

		dialogue_component.stop_talking()
		dialogue_component.add_line("have a good day")
		dialogue_component.start_talking()
