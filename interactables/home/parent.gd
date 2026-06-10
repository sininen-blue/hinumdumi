extends Node3D

@export var player: Player

signal level_complete

var queue: Array[String] = []
var submitted_items: Array[Item] = []
var is_talking: bool = false
var current_line_index: int = 0
var current_char_index: int = 0

@onready var home: Home = self.get_parent()
@onready var lines: Array[String] = home.lines
@onready var dialgoue_label: Label3D = $DialgoueLabel
@onready var character_timer: Timer = $CharacterTimer
@onready var submit_debounce_timer: Timer = $SubmitDebounceTimer
@onready var line_timer: Timer = $LineTimer


func _ready() -> void:
	home.finished_requirements.connect(_on_home_finished_requirements)
	PlayerInventory.removed_item.connect(_on_player_inventory_removed_item)


func _input(event: InputEvent) -> void:
	if not player:
		return

	if event.is_action_pressed("interact"):
		reset()
		if PlayerStates.left_home == false:
			init_dialogue()


func init_dialogue() -> void:
	give_player_money()
	for line: String in lines:
		if line == "":
			list_requirements()
			continue
		if line == "[m]":
			queue.append("here's " + str(home.starting_cash) + " pesos")
			continue
		queue.append(line)

	if "[m]" not in lines:
		queue.append("here's " + str(home.starting_cash) + " pesos")

	dialgoue_label.text = ""
	start_talking()
	is_talking = true


func list_requirements() -> void:
	var requirements: Dictionary[Item, int] = home.requirements
	var line: String = ""
	for item: Item in requirements.keys():
		var number_string: String = str(requirements[item])
		var item_name: String = ""

		if requirements[item] > 1:
			item_name = item.plural_description
		else:
			item_name = item.singular_description

		line = number_string + " " + item_name

		queue.append(line)


## Utils
func add_character(character: String) -> void:
	dialgoue_label.text += character
	character_timer.start()


func reset() -> void:
	dialgoue_label.text = ""
	queue = []
	is_talking = false
	current_line_index = 0
	current_char_index = 0

	character_timer.stop()
	submit_debounce_timer.stop()
	line_timer.stop()


func give_player_money() -> void:
	PlayerInventory.money = home.starting_cash


func start_talking() -> void:
	add_character(queue[current_line_index][current_char_index])


func _on_player_inventory_removed_item(item: Item) -> void:
	submitted_items.append(item)
	submit_debounce_timer.start()


func _on_home_finished_requirements() -> void:
	reset()
	queue.append("Okay, thank you")
	queue.append("Dinner at 8")
	start_talking()

	level_complete.emit()


func _on_character_timer_timeout() -> void:
	current_char_index += 1

	if current_char_index + 1 > queue[current_line_index].length():
		line_timer.start()
		return

	start_talking()


func _on_line_timer_timeout() -> void:
	current_line_index += 1

	if current_line_index + 1 > len(queue):
		is_talking = false
		reset()
		return

	current_char_index = 0
	dialgoue_label.text = ""

	start_talking()


func _on_submit_debounce_timer_timeout() -> void:
	reset()
	if home.requirements.is_empty():
		return
	queue.append("All that's left is")
	list_requirements()
	start_talking()


func _on_interact_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body


func _on_interact_area_body_exited(body: Node3D) -> void:
	if body is Player:
		if PlayerStates.left_home == false:
			PlayerStates.left_home = true

		player = null
		reset()
