extends Node

@export var inventory: Dictionary[Item, int] = { }
@export var left_hand: Hand
@export var right_hand: Hand


func add_item(item: Item) -> void:
	if inventory.get(item, null) == null:
		inventory[item] = 0

	inventory[item] += 1

	var total_items: int = inventory.values().reduce(sum)
	if total_items % 2 == 0:
		left_hand.add_item(item)
	else:
		right_hand.add_item(item)


func remove_item(item: Item) -> void:
	if inventory.get(item, null) == null:
		printerr("Item does not exist: ", item.name)
		return

	inventory[item] -= 1
	if inventory[item] <= 0:
		inventory.erase(item)


func sum(accum: int, number: int) -> int:
	return accum + number
