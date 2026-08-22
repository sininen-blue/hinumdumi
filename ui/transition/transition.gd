extends Control
class_name LevelTransition

signal done_transition

@export var night_number: int = 1
@export var missing_number: int = 1

@onready var timer: Timer = $Timer
@onready var title_label: Label = $TitleLabel
@onready var missing_label: Label = $MissingLabel


func _ready() -> void:
	timer.start()
	title_label.text = "Night %d" % night_number
	missing_label.text = "There are %d missing children" % missing_number


func _on_timer_timeout() -> void:
	done_transition.emit()
