extends FadingTutorialText


@export var player: Player


func _ready() -> void:
	super._ready()
	start_count()


func _process(delta: float) -> void:
	super._process(delta)
	
	has_done_action = PlayerStates.has_moved
	if PlayerStates.has_moved == false:
		if player.velocity != Vector3.ZERO:
			PlayerStates.has_moved = true
