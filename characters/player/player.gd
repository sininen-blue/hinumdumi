extends CharacterBody2D

@export var speed: float = 200

var is_talking: bool = false

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_right", "move_left", "move_up", "move_down")
	
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
