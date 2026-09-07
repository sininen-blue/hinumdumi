extends Node3D
class_name Shop

const VOICE_1 = preload("uid://ccs7l77g45yb3")
const VOICE_2 = preload("uid://dgrc26siix5mh")
const VOICE_3 = preload("uid://d2uvlom5k01is")
const VOICE_4 = preload("uid://c3cbbhodkrm2q")
const VOICE_5 = preload("uid://gev8oqd86ed7")
const BUY_SOUND = preload("uid://b5y30v6j1p81l")
const NO_BUY_SOUND = preload("uid://j3wy7mpq6ves")
const RETURN_SOUND = preload("uid://d0n0fuqf5cynu")

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
var buy_sound_player: AudioStreamPlayer3D
var no_buy_sound_player: AudioStreamPlayer3D
var return_sound_player: AudioStreamPlayer3D

@onready var dialogue_component: DialogueComponent = $DialogueComponent
@onready var item_interacts: ItemInteracts = $ItemInteracts


func _ready() -> void:
	dialogue_component.voices = [
		VOICE_1,
		VOICE_2,
		VOICE_3,
		VOICE_4,
		VOICE_5,
	]
	
	buy_sound_player = AudioStreamPlayer3D.new()
	buy_sound_player.stream = BUY_SOUND
	add_child(buy_sound_player)
	
	no_buy_sound_player = AudioStreamPlayer3D.new()
	no_buy_sound_player.stream = NO_BUY_SOUND
	add_child(no_buy_sound_player)
	
	return_sound_player = AudioStreamPlayer3D.new()
	return_sound_player.stream = RETURN_SOUND
	add_child(return_sound_player)


func _on_item_interact(item: Item) -> void:
	if PlayerInventory.money < item.base_cost:
		no_buy_sound_player.play()
	
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
		buy_sound_player.play()
		
		_check_returns()


func _on_return_interact(item: Item) -> void:
	for player_item: Item in PlayerInventory.inventory.keys():
		if player_item != item:
			continue

		if item.origin == self:
			var hand: Hand = PlayerInventory.remove_item(item)
			item_interacts.recieve(item, hand)
			PlayerInventory.money += item.base_cost
			inventory[item] += 1
			return_sound_player.play()
		
		_check_returns()


func _on_shoppable_area_body_entered(body: Node3D) -> void:
	if body is Player:
		self.player = body

		for line in intro_lines:
			dialogue_component.add_line(line)
		dialogue_component.start_talking()
		
		_check_returns()


func _on_shoppable_area_body_exited(body: Node3D) -> void:
	if body is Player:
		self.player = null

		dialogue_component.stop_talking()
		
		for line in outro_line:
			dialogue_component.add_line(line)
		dialogue_component.start_talking()


func _check_returns():
	for return_interact in item_interacts.return_interacts:
		var origin: Shop = return_interact.item.origin
		if is_instance_valid(origin) and PlayerInventory.has_returnable(origin):
			return_interact.visible = true
		else:
			return_interact.visible = false
