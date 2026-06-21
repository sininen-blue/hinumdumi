extends State

@export var monster: Monster
@export var nav: NavigationAgent3D

@export var speed: float = 3.0

var player: Player
var next_path_position: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO

@onready var investigate: Node = %Investigate
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hitbox: Area3D = $"../../Hitbox"
@onready var jumpscare: Node = %Jumpscare


func enter() -> void:
	animation_player.speed_scale = 1.5
	animation_player.play("Lando Walk/Armature|mixamo_com|Layer0")


func exit() -> void:
	animation_player.speed_scale = 1


func physics_update(_delta: float) -> void:
	nav.target_position = monster.player.position
	next_path_position = nav.get_next_path_position()
	direction = monster.global_position.direction_to(next_path_position)
	monster.velocity = direction * speed
	monster.move_and_slide()


func lost_player() -> void:
	pass


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		state_machine.change_state(jumpscare)
