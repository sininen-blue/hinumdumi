extends Node3D

class_name Shop
const SHOPPABLE_ITEM: PackedScene = preload("res://interactables/shop/shoppable_item.tscn")

@export var debug: bool = false
@export var shoppableItem: PackedScene
@export var inventory: Dictionary[Item, int]
@export var cost_modifier: float = 1
@export var shoppable_offset: float = 2

@export var intro_lines: Array[String] = [
	"What are you buying?",
]
@export var outro_line: Array[String] = [
	"Ogey",
]

var player: Player

@onready var debug_label: Label3D = $Debug/DebugLabel
@onready var display_origin: Node3D = $DisplayOrigin
@onready var dialogue_component: DialogueComponent = $DialogueComponent

# return behavior
# if the player looks at point (shopkeep)
# if player has item from shop (same origin)
# shopkeep displayes interactables for each item
# if player interacts, return item, get money back, with fee


func _ready() -> void:
	toggle_display()

	var items: Array[Item] = inventory.keys()

	for item: Item in items:
		var shoppable: ShoppableItem = SHOPPABLE_ITEM.instantiate()
		shoppable.interacted.connect(_on_shoppable_item_interacted)
		shoppable.item = item
		shoppable.amount = inventory[item]

		display_origin.add_child(shoppable)

	arrange_items()


func _process(_delta: float) -> void:
	debug_label.text = "test"


func buy(shoppable: ShoppableItem) -> void:
	var stock: int = inventory.get(shoppable.item, 0)
	if stock > 0:
		inventory[shoppable.item] -= 1
		#if inventory[shoppable.item] <= 0: NOTE: removed for return
		#inventory.erase(shoppable.item)

		var target: Hand = PlayerInventory.add_item(shoppable.item)
		shoppable.remove_stock(target)


func toggle_display():
	for shoppable: ShoppableItem in display_origin.get_children():
		shoppable.visible = !display_origin.visible

	display_origin.visible = !display_origin.visible


func arrange_items():
	var children: Array[Node] = display_origin.get_children()
	var item_amount: float = children.size()

	var center: float = (item_amount - 1) / 2.0

	for i in range(item_amount):
		var shoppable: ShoppableItem = children[i]
		shoppable.position = Vector3.ZERO
		var distance := i - center
		shoppable.position += Vector3(0, 0, shoppable_offset * distance)


func _on_shoppable_area_body_entered(body: Node3D) -> void:
	if body is Player:
		self.player = body
		toggle_display()

		dialogue_component.add_line("what are you buying?")
		dialogue_component.start_talking()


func _on_shoppable_area_body_exited(body: Node3D) -> void:
	if body is Player:
		self.player = null
		toggle_display()

		dialogue_component.stop_talking()
		dialogue_component.add_line("have a good day")
		dialogue_component.start_talking()


func _on_shoppable_item_interacted(shoppable: ShoppableItem) -> void:
	if not player:
		return

	if PlayerInventory.money >= shoppable.item.base_cost:
		PlayerInventory.money -= shoppable.item.base_cost
		buy(shoppable)


func _on_shopkeep_interact_interacted() -> void:
	#for item in PlayerInventory.inventory:
	#if item.origin == self:
	# show list of returnable items as interact areas
	# each interact area increases stock

	# TODO: probably rework some of the systems
	# primarily rework stock handling
	# stock display handling
	# into separate components
	pass


func _on_item_interact(item: Item) -> void:
	if PlayerInventory.money >= item.base_cost:
		var stock: int = inventory.get(item, 0)
		if stock > 0:
			item.origin = self
			inventory[item] -= 1
			PlayerInventory.add_item(item)
			#if inventory[shoppable.item] <= 0: NOTE: removed for return
			#inventory.erase(shoppable.item)

			#var target: Hand = PlayerInventory.add_item(shoppable.item)
			#shoppable.remove_stock(target)


func _on_return_interact(item: Item) -> void:
	for player_item: Item in PlayerInventory.inventory.keys():
		if player_item != item:
			continue

		if item.origin == self:
			PlayerInventory.remove_item(item)
			PlayerInventory.money += item.base_cost
			inventory[item] += 1
