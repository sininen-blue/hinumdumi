extends RayCast3D

@export var wander_distance_threshold: float = 20
@export var scanning_distance_threshold: float = 40
@export var investigate_distance_threshold: float = 100

### Percentage increase of distance i.e. if you're
### 200m away, you'll be calculated as 240m away
@export var crouch_modifier: float = 1.5

@onready var player: Player = self.get_parent().player
@onready var vision_loss_timer: Timer = $VisionLossTimer
@onready var vision_gain_timer: Timer = $VisionGainTimer

# states
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var wander: Node = %Wander
@onready var scanning: Node = %Scanning
@onready var investigate: Node = %Investigate
@onready var hunt: Node = %Hunt

var can_see_player: bool = false


func _process(_delta: float) -> void:
	if !player:
		return
	self.look_at(player.head.global_position - Vector3(0, 0.3, 0))
	if self.is_colliding() == false:
		return

	if _can_see_player():
		vision_loss_timer.start()
		if vision_gain_timer.is_stopped():
			vision_gain_timer.start()
	else:
		if vision_gain_timer.is_stopped() == false:
			vision_gain_timer.stop()


func _can_see_player() -> bool:
	if self.get_collider() is not Player:
		return false

	if PlayerStates.is_hiding:
		return false

	var player_distance: float = self.global_position.distance_to(player.global_position)

	if PlayerStates.is_crouching:
		player_distance *= crouch_modifier

	match state_machine.current_state:
		wander:
			if player_distance < wander_distance_threshold:
				return true
		scanning:
			if player_distance < scanning_distance_threshold:
				return true
		investigate:
			if player_distance < investigate_distance_threshold:
				return true

	return false


func _on_vision_loss_timer_timeout() -> void:
	state_machine.last_known_position = player.global_position
	state_machine.change_state(investigate)


func _on_vision_gain_timer_timeout() -> void:
	state_machine.change_state(hunt)
