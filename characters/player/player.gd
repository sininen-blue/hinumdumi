extends CharacterBody2D

@export var speed: float = 200

var is_talking: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Marker2D = $Pivot


# TODO: scene changing transition
# TODO: dialogue box proper
# TODO: check if items work in state
# TODO: first minigame


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_right", "move_left", "move_up", "move_down")
	pivot.look_at(position + direction)
	
	if direction != Vector2.ZERO:
		sprite.flip_h = direction.x > 0
	else:
		animation_player.play("idle")
	
	if abs(direction.x) > 0:
		animation_player.play("walk_side")
	elif direction == Vector2.DOWN:
		animation_player.play("walk_front")
	elif direction == Vector2.UP:
		animation_player.play("walk_back")
	
	if is_talking:
		direction = Vector2.ZERO
	velocity = direction * speed
	move_and_slide()


func _on_actionable_finder_area_entered(area: Area2D) -> void:
	DialogueManager.connect("dialogue_ended", _finished_dialogue)
	is_talking = true
	area.action()

func _finished_dialogue(_resource: Resource) ->void:
	is_talking = false
	DialogueManager.disconnect("dialogue_ended", _finished_dialogue)
