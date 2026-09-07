extends RayCast3D


@export var vision_gain_threshold: float = 1.0
@export var vision_loss_threshold: float = 1.5
@export var wander_distance_threshold: float = 20
@export var scanning_distance_threshold: float = 40
@export var investigate_distance_threshold: float = 100

### Percentage increase of distance i.e. if you're
### 200m away, you'll be calculated as 240m away
@export var crouch_modifier: float = 1.5

var vision_gain: float = 0.0
var vision_loss: float = 0.0

@onready var player: Player = self.get_parent().player
@onready var vision_loss_timer: Timer = $VisionLossTimer
@onready var vision_gain_timer: Timer = $VisionGainTimer

# states
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var wander: Node = %Wander
@onready var scanning: Node = %Scanning
@onready var investigate: Node = %Investigate
@onready var hunt: Node = %Hunt
@onready var detected: AudioStreamPlayer3D = $Detected
@onready var undetected: AudioStreamPlayer3D = $Undetected

var can_see_player: bool = false


func _process(delta: float) -> void:
	if !player:
		return
	self.look_at(player.head.global_position - Vector3(0, 0.3, 0))
	if self.is_colliding() == false:
		return

	if _can_see_player():
		vision_loss = 0
		if state_machine.current_state != hunt:
			vision_gain += 1 * delta
	else:
		vision_gain = 0
		if state_machine.current_state == hunt:
			vision_loss += 1 * delta
	
	if vision_gain >= vision_gain_threshold and state_machine.current_state != hunt:
		state_machine.change_state(hunt)
		detected.play()
		player.detected.play() # NOTE: will break things probably at some point
	
	if vision_loss >= vision_loss_threshold and state_machine.current_state == hunt:
		state_machine.last_known_position = player.global_position
		state_machine.change_state(investigate)
		undetected.play()
		player.undetected.play()


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
		hunt:
			return true

	return false
