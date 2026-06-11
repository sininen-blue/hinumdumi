extends Node3D

class_name DialogueComponent

signal finished_talking()
signal started_talking()
signal finished_line(indx: int, line: String)

@export var character_delay: float = 0.05
@export var line_delay: float = 0.5

@onready var label: Label3D = $Label
@onready var character_timer: Timer = $CharacterTimer
@onready var line_timer: Timer = $LineTimer

var queue: Array[String] = []

var current_line_index: int = 0
var current_char_index: int = 0


func _ready() -> void:
	character_timer.wait_time = character_delay
	line_timer.wait_time = line_delay
	_reset()


func start_talking() -> void:
	started_talking.emit()
	_reset()
	character_timer.start()


func stop_talking() -> void:
	queue.clear()
	_reset()


func add_line(line: String) -> void:
	queue.append(line)


func _reset() -> void:
	label.text = ""
	current_char_index = 0
	current_line_index = 0
	character_timer.stop()
	line_timer.stop()


func _on_character_timer_timeout() -> void:
	label.text += queue[current_line_index][current_char_index]
	current_char_index += 1

	if current_char_index >= queue[current_line_index].length():
		line_timer.start()
		return

	character_timer.start()


func _on_line_timer_timeout() -> void:
	finished_line.emit(current_line_index, queue[current_line_index])

	label.text = ""
	current_char_index = 0
	current_line_index += 1

	if current_line_index >= len(queue):
		finished_talking.emit()
		_reset()
		return

	character_timer.start()
