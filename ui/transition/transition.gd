extends Control
class_name LevelTransition

signal done_transition

@export var night_number: int = 12
@export var missing_number: int = 1

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title_label: RichTextLabel = $TitleLabel
@onready var missing_label: RichTextLabel = $MissingLabel


func _ready() -> void:
	animation_player.play("display")
	timer.start()
	title_label.text = "Night [wave]%s[/wave]" % _romanize(night_number)
	missing_label.text = "There are [shake]%s[/shake] missing children" % _romanize(missing_number)


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
	nums.sort_custom(func(a, b): return a > b )
	var roman: String = ""
	
	while n > 0:
		for i: int in nums:
			if n >= i:
				n -= i
				roman += symbols[i]
				continue
		
	return roman
