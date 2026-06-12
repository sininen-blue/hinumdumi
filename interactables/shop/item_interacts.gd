extends Node3D

class_name ItemInteracts

const SHOP_INTERACT: PackedScene = preload("res://interactables/shop/shop_interact.tscn")
const RETURN_INTERACT: PackedScene = preload("res://interactables/shop/return_interact.tscn")

@onready var shop: Shop = self.get_parent()

var index: int = 0
var offset: float = 1.2

var shop_display_list: Array[ShopDisplay]


func _ready() -> void:
	var inventory: Dictionary[Item, int] = shop.inventory

	for item: Item in inventory.keys():
		var shop_interact: ShopInteract = SHOP_INTERACT.instantiate()
		shop_interact.interacted.connect(shop._on_item_interact)
		shop_interact.item = item

		var return_interact: ShopInteract = RETURN_INTERACT.instantiate()
		return_interact.interacted.connect(shop._on_return_interact)
		return_interact.item = item

		var shop_display: ShopDisplay = ShopDisplay.new()
		shop_display.item = item
		shop_display.initial_amount = inventory[item]

		var position_offset: Vector3 = Vector3.RIGHT * index * offset
		add_child(shop_interact)
		add_child(shop_display)
		add_child(return_interact)
		shop_interact.position += position_offset
		shop_display.position += position_offset
		return_interact.position += position_offset + Vector3(0, -0.4, 0)

		shop_display_list.append(shop_display)

		index += 1


func send(item: Item, hand: Hand) -> void:
	for display: ShopDisplay in shop_display_list:
		if display.item == item:
			display.send(hand)
