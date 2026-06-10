extends Node3D

@export var player: Player

var queue: Array[String] = []
var is_talking: bool = false
var current_line_index: int = 0
var current_char_index: int = 0

@onready var home: Home = self.get_parent()
@onready var lines: Array[String] = home.lines
@onready var dialgoue_label: Label3D = $DialgoueLabel
@onready var character_timer: Timer = $CharacterTimer
@onready var line_timer: Timer = $LineTimer

# TODO: "and" for the last item
# TODO: closing speech
# TODO: item submission lines
# TODO: acceptance lines


func _input(event: InputEvent) -> void:
	if not player:
		return

	if event.is_action_pressed("interact"):
		reset()
		init_dialogue()


func init_dialogue() -> void:
	for line: String in lines:
		if line == "":
			list_requirements()
			continue
		queue.append(line)

	queue.append("here's " + str(home.starting_cash) + " pesos")

	dialgoue_label.text = ""
	add_character(queue[current_line_index][current_char_index])
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


func add_character(character: String) -> void:
	dialgoue_label.text += character
	character_timer.start()


func _on_character_timer_timeout() -> void:
	current_char_index += 1

	if current_char_index + 1 > queue[current_line_index].length():
		line_timer.start()
		return

	add_character(queue[current_line_index][current_char_index])


func _on_line_timer_timeout() -> void:
	current_line_index += 1

	if current_line_index + 1 > len(queue):
		is_talking = false
		give_player_money()
		reset()
		return

	current_char_index = 0
	dialgoue_label.text = ""

	add_character(queue[current_line_index][current_char_index])


func give_player_money() -> void:
	PlayerInventory.money = home.starting_cash


func reset() -> void:
	dialgoue_label.text = ""
	queue = []
	is_talking = false
	current_line_index = 0
	current_char_index = 0


func _on_interact_area_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body


func _on_interact_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player = null
		reset()
