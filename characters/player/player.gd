extends CharacterBody2D
class_name Player

@export var camera_zoom: float = 1.0

@export var speed: float = 100
@export var accel: float = 20
@export var decel: float = 20

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Marker2D = $Pivot
@onready var exclamation: Sprite2D = $Exclamation
@onready var actionable_finder: Area2D = $Pivot/ActionableFinder


var direction: Vector2 = Vector2.ZERO
var can_interact: bool = false

enum State {IDLE, MOVING, TALKING}
var current_state: int = State.IDLE



func _ready() -> void:
	$Camera2D.zoom = Vector2(camera_zoom, camera_zoom)



func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("move_right", "move_left", "move_up", "move_down")
	
	
	
	_handle_states()
	_handle_animations()
	
	move_and_slide()

func _handle_states() -> void:
	match current_state:
		State.IDLE:
			actionable_finder.monitoring = Input.is_action_pressed("interact") && can_interact
			velocity = velocity.move_toward(Vector2.ZERO, decel)
			
			if direction != Vector2.ZERO:
				current_state = State.MOVING
		State.MOVING:
			actionable_finder.monitoring = Input.is_action_pressed("interact") && can_interact
			pivot.look_at(pivot.position + position + direction)
			velocity = velocity.move_toward(direction * speed, accel)
			
			if direction == Vector2.ZERO:
				current_state = State.IDLE
		State.TALKING:
			velocity = velocity.move_toward(Vector2.ZERO, decel * 2)


func _handle_animations() -> void:
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.MOVING:
			sprite.flip_h = direction.x > 0
			
			if abs(direction.x) > 0:
				animation_player.play("walk_side")
			elif direction == Vector2.DOWN:
				animation_player.play("walk_front")
			elif direction == Vector2.UP:
				animation_player.play("walk_back")
		State.TALKING:
			pass

func _on_actionable_finder_area_entered(area: Area2D) -> void:
	exclamation.visible = true
	current_state = State.TALKING
	DialogueManager.connect("dialogue_ended", _finished_dialogue)
	area.action()

func _finished_dialogue(_resource: Resource) ->void:
	current_state = State.IDLE
	DialogueManager.disconnect("dialogue_ended", _finished_dialogue)


func _on_actionable_detector_area_entered(_area: Area2D) -> void:
	can_interact = true
	exclamation.visible = true


func _on_actionable_detector_area_exited(_area: Area2D) -> void:
	can_interact = false
	exclamation.visible = false
