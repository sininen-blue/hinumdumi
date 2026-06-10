extends Node

signal removed_item(item: Item)

@export var inventory: Dictionary[Item, int] = { }
@export var left_hand: Hand
@export var right_hand: Hand
@export var money: float = 0


# adds an item to the inventory and picks a hand to represent it
func add_item(item: Item) -> Hand:
	if inventory.get(item, null) == null:
		inventory[item] = 0

	inventory[item] += 1

	var total_items: int = inventory.values().reduce(sum)
	if total_items % 2 == 0:
		left_hand.add_item(item)
		return left_hand
	else:
		right_hand.add_item(item)
		return right_hand


func remove_item(item: Item) -> void:
	if inventory.get(item, null) == null:
		printerr("Item does not exist: ", item.name)
		return

	inventory[item] -= 1
	if inventory[item] <= 0:
		inventory.erase(item)

	if left_hand.has_item(item):
		left_hand.remove_item(item)
	else:
		right_hand.remove_item(item)

	removed_item.emit(item)


func sum(accum: int, number: int) -> int:
	return accum + number
