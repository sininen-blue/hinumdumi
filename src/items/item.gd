extends Resource

class_name Item

@export_group("Primary")
## Name of the item
@export var name: String
## Used for dialogue, i.e. bottle of ketchup
@export var singular_description: String
## Used for dialogue, i.e. bottles of ketchup
@export var plural_description: String
## Scene of the items model used in shopkeep showcase, and in inventory
@export var model: PackedScene = preload("res://src/items/item_placeholder.tscn")
## Base cost of the item
@export var base_cost: float = 1.0

@export_group("Attributes")
## Weight of the item
@export_range(0, 20, 0.1, "suffix:kg") var weight: float = 1
## If the item requires two hands
@export var two_hands: bool = false
## How likely the item is to fall, with 1 being always on "fall likely" events
@export_range(0, 1) var fiddliness: float = 0

var origin: Shop
