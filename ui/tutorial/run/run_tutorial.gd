extends FadingTutorialText


@export var player: Player


func _process(delta: float) -> void:
	super._process(delta)
	
	has_done_action = PlayerStates.has_sprinted
	if "Run" in player.state_machine.current_state.name:
		PlayerStates.has_sprinted = true
	
	if PlayerStates.left_home and has_done_action == false:
		start_count()
