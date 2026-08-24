extends Label3D
class_name FadingTutorialText

@export var has_done_action: bool = false
@export var threshold: float = 5

var is_shown: bool = false
var is_counting: bool = false
var time: float = 0


func _ready() -> void:
	self.transparency = 1.0


func start_count() -> void:
	is_counting = true


func _process(delta: float) -> void:
	if is_counting == true:
		time += 1 * delta
	
	if is_shown == false and has_done_action:
		queue_free.call_deferred()
	
	
	if is_shown and has_done_action:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "transparency", 1.0, 1)
		await tween.finished
		queue_free.call_deferred()
	
	
	if time >= threshold and has_done_action == false and is_shown == false:
		is_counting = false
		is_shown = true
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "transparency", 0.0, 1)
