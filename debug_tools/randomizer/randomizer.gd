extends Node
class_name Randomizer

const EGG = preload("uid://bnwb6eo5yt56w")
const RICE = preload("uid://cibahbmjhia64")
const SALT = preload("uid://dduxxviuf6umn")
const SOY_SAUCE = preload("uid://dqln4etsscmsq")
const VINEGAR = preload("uid://bhsq474tgbqxa")

@export var max_items: int = 3
@export var min_items: int = 2
@export var max_item_count: int = 3
@export var min_item_count: int = 1

@export var level: Node3D
@export var home: Home


var item_set = [
	EGG,
	RICE,
	SALT,
	SOY_SAUCE,
	VINEGAR,
]


func _ready() -> void:
	var shops: Array[Node] = _get_shops()
	var item_indexes: Dictionary[int, int] = _generate_random_items()
	var items: Dictionary[Item, int] = {}
	for i in item_indexes.keys():
		items[item_set[i]] = item_indexes[i]
	
	var price: int = 0
	for item in items.keys():
		price += item.base_cost * items[item]
	
	home.starting_cash = price + 10
	home.requirements = items
	
	for item in items.keys():
		var shop: Shop = shops.pick_random() as Shop
		shop.inventory = {}
		shop.inventory[item] = items[item]
	
	for shop: Shop in shops:
		while len(shop.inventory.keys()) < 2:
			var candidate: Item = item_set.pick_random()
			if shop.inventory.has(candidate):
				continue
			shop.inventory[candidate] = randi_range(min_item_count, max_item_count)
	



func _get_shops() -> Array[Node]:
	return level.get_tree().get_nodes_in_group("shops")


func _generate_random_items() -> Dictionary[int, int]:
	var item_count: int = randi_range(min_items, max_items)
	
	var chosen_item_indexes: Dictionary[int, int]
	while len(chosen_item_indexes) < item_count:
		var candidate: int = randi_range(0, len(item_set)-1)
		if candidate not in chosen_item_indexes:
			chosen_item_indexes[candidate] = randi_range(min_item_count, max_item_count)
	
	return chosen_item_indexes
