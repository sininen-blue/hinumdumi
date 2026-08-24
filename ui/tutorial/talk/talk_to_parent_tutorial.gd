extends FadingTutorialText


func _ready() -> void:
	super._ready()
	start_count()


func _process(delta: float) -> void:
	super._process(delta)
	
	has_done_action = PlayerStates.has_talked_to_parent
