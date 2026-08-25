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
	title_label.text = "Night %d" % _romanize(night_number)
	missing_label.text = "There are %d missing children" % missing_number


func _on_timer_timeout() -> void:
	done_transition.emit()


func _romanize(n: int) -> String:
	var symbols: Dictionary[int, String] = {
		1: "I",
		4: "IV",
		5: "V",
		9: "IX",
		10: "X",
	}
	var nums: Array[int] = symbols.keys()
	nums.sort()
	
	var roman: String = ""
	while n > 0:
		for i: int in nums:
			if n > i:
				n -= i
				roman += symbols[i]
		
	return roman
