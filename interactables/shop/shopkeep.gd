extends Node3D

class_name Shop
signal changed_selection(index: int)
const SHOPPABLE_ITEM: PackedScene = preload("res://interactables/shop/shoppable_item.tscn")

@export var debug: bool = false
@export var shoppableItem: PackedScene
@export var inventory: Dictionary[Item, int]
@export var cost_modifier: float = 1

@export var shoppable_offset: float = 1

var selected_item: Item
var selected_index: int = 0:
	set = _set_selected_index

var player: Player

@onready var debug_label: Label3D = $DebugLabel

@onready var display_origin: Node3D = $DisplayOrigin


func _ready() -> void:
	var items: Array[Item] = inventory.keys()
	var item_amount: int = len(inventory.keys())

	for item: Item in items:
		var shoppable: ShoppableItem = SHOPPABLE_ITEM.instantiate()
		shoppable.item = item

		display_origin.add_child(shoppable)

	var index: int = 0
	var center: float = float(item_amount) / 2
	for shoppable: ShoppableItem in display_origin.get_children():
		var is_first_half: bool = index < float(item_amount) / 2
		var distance: float = index - center
		if is_first_half:
			shoppable.global_position += Vector3(0, 0, -shoppable_offset)
		else:
			shoppable.global_position += Vector3(0, 0, shoppable_offset)
		index += 1


func _input(event: InputEvent) -> void:
	if player:
		return

	if event.is_action_pressed("buy"):
		pass # figure out if getting the index of the dictionary keys
		# has the same order in every runC


func _process(_delta: float) -> void:
	debug_label.text = str(selected_item)


func _set_selected_index(new_index: int) -> void:
	var clamped = clampi(new_index, 0, len(inventory))
	selected_index = clamped

	changed_selection.emit(selected_index)


func toggle_display():
	display_origin.visible = !display_origin.visible


func _on_shoppable_area_body_entered(body: Node3D) -> void:
	if body is Player:
		self.player = body
		toggle_display()


func _on_shoppable_area_body_exited(body: Node3D) -> void:
	if body is Player:
		self.player = null
		toggle_display()
