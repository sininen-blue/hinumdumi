extends Node3D

@export var player: Player

signal level_complete

var submitted_items: Array[Item] = []

@onready var home: Home = self.get_parent()
@onready var lines: Array[String] = home.lines
@onready var submit_debounce_timer: Timer = $SubmitDebounceTimer
@onready var dialogue_component: DialogueComponent = $DialogueComponent


func _ready() -> void:
	home.finished_requirements.connect(_on_home_finished_requirements)
	PlayerInventory.removed_item.connect(_on_player_inventory_removed_item)


func _input(event: InputEvent) -> void:
	if not player:
		return

	if event.is_action_pressed("interact"):
		if PlayerStates.left_home == false:
			init_dialogue()


func init_dialogue() -> void:
	give_player_money()

	for line: String in lines:
		if line == "":
			list_requirements()
			continue
		if line == "[m]":
			dialogue_component.add_line("here's " + str(home.starting_cash) + " pesos")
			continue
		dialogue_component.add_line(line)

	if "[m]" not in lines:
		dialogue_component.add_line("here's " + str(home.starting_cash) + " pesos")

	dialogue_component.start_talking()


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

		dialogue_component.add_line(line)


## Utils
func give_player_money() -> void:
	PlayerInventory.money = home.starting_cash


func _on_player_inventory_removed_item(item: Item) -> void:
	submitted_items.append(item)
	submit_debounce_timer.start()


func _on_home_finished_requirements() -> void:
	dialogue_component.add_line("Okay, thank you")
	dialogue_component.add_line("Dinner at 8")
	dialogue_component.start_talking()

	level_complete.emit()


func _on_submit_debounce_timer_timeout() -> void:
	if home.requirements.is_empty():
		return
	dialogue_component.queue.clear()
	dialogue_component.add_line("All that's left is")
	list_requirements()
	dialogue_component.start_talking()


func _on_interact_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body


func _on_interact_area_body_exited(body: Node3D) -> void:
	if body is Player:
		if PlayerStates.left_home == false:
			PlayerStates.left_home = true

		player = null
		dialogue_component.stop_talking()
