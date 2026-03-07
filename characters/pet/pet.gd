extends CharacterBody2D

@export var handler: PetHandler
@export var speed: float = 200
@export var accel: float = 20
@export var decel: float = 5
@export var max_idle: float = 5
@export var min_idle: float = 3

enum State {IDLE, MOVE, PET}
var current_state: int = State.IDLE

@onready var idle_timer: Timer = $IdleTimer

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(handler.global_position)
	
	match current_state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, decel)
			
			if global_position.distance_to(handler.global_position) > 200:
				current_state = State.MOVE
		State.MOVE:
			velocity = velocity.move_toward(direction * speed, accel)
			
			if global_position.distance_to(handler.global_position) < 20:
				idle_timer.start(randf_range(min_idle, max_idle))
				current_state = State.IDLE
		State.PET:
			pass
	
	
	move_and_slide()


func _on_idle_timer_timeout() -> void:
	current_state = State.MOVE
