extends State

@export var player: Player
@export var stamina_regen: float = 1

var can_hide: bool = false

@onready var idle_state: State = %IdleState


func enter() -> void:
	PlayerStates.is_hiding = true
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player, "global_position", player.hideable.global_position, 0.5)


func exit() -> void:
	PlayerStates.is_hiding = false
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(player, "global_position", player.hideable.exit_area.global_position, 0.2)


func update(delta: float) -> void:
	player.current_stamina += stamina_regen * delta


func physics_update(_delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_hide"):
		state_machine.change_state(idle_state)
