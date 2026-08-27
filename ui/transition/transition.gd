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
	
	match night_number:
		1:
			missing_label.text = "It's like he can [wave]hear[/wave] you run"
		2:
			missing_label.text = "Keep close to walls and corridors"
		3:
			missing_label.text = "He can't hear you when you sneak"
		4:
			missing_label.text = "Don't forgot what mom asked for"
		_:
			missing_label.text = "You survived another night"


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
