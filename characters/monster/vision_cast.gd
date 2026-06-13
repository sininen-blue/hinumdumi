extends RayCast3D

@export var wander_distance_threshold: float = 20
@export var scanning_distance_threshold: float = 40
@export var investigate_distance_threshold: float = 100

@onready var player: Player = self.get_parent().player
@onready var vision_loss_timer: Timer = $VisionLossTimer

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
	self.look_at(player.global_position)

	if self.is_colliding():
		if self.get_collider() is Player:
			can_see_player = true
			vision_loss_timer.start()
		else:
			can_see_player = false

	if can_see_player:
		var player_distance: float = self.global_position.distance_to(player.global_position)
		match state_machine.current_state:
			wander:
				if player_distance < wander_distance_threshold:
					state_machine.change_state(hunt)
			scanning:
				if player_distance < scanning_distance_threshold:
					state_machine.change_state(hunt)
			investigate:
				if player_distance < investigate_distance_threshold:
					state_machine.change_state(hunt)


func _on_vision_loss_timer_timeout() -> void:
	state_machine.last_known_position = player.global_position
	state_machine.change_state(investigate)
