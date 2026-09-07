extends Node
class_name Randomizer

const CHIPS = preload("uid://b5d67xvkem2kq")
const COEK = preload("uid://ecui8hscpakw")
const COFFEE = preload("uid://kogmu7aon258")
const CORNED = preload("uid://ohu3qbhjeege")
const EGG = preload("uid://bnwb6eo5yt56w")
const MOUNTAIN_DAW = preload("uid://c5syujc0qyfw6")
const PAITOS = preload("uid://dmwea0cpy4yi2")
const PEANUTS = preload("uid://d1gomtwbrkedl")
const RICE = preload("uid://cibahbmjhia64")
const SALT = preload("uid://dduxxviuf6umn")
const SARAP = preload("uid://c5gtg11nuj6co")
const SARDINES = preload("uid://c3b05jhjamh1w")
const SOY_SAUCE = preload("uid://dqln4etsscmsq")
const SPAM = preload("uid://bo66ogt4m5gfv")
const VINEGAR = preload("uid://bhsq474tgbqxa")

@export var max_items: int = 3
@export var min_items: int = 2
@export var max_item_count: int = 3
@export var min_item_count: int = 1

@export var level: Node3D
@export var home: Home


var item_set = [
	CHIPS,
	COEK,
	COFFEE,
	CORNED,
	EGG,
	MOUNTAIN_DAW,
	PAITOS,
	PEANUTS,
	RICE,
	SALT,
	SARAP,
	SARDINES,
	SOY_SAUCE,
	SPAM,
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
	
	home.starting_cash = price
	home.requirements = items
	
	# NOTE: current version has possibility of spawning all reqiured
	# items in one shop, is intended, will be less likely as 
	# more items get added, the luck is sometiems good
	for shop: Shop in shops:
		shop.inventory = {}
	
	for item in items.keys():
		var shop: Shop = shops.pick_random() as Shop
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
