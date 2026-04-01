extends CharacterBody3D
class_name Player

@export_category("Camera")
@export var sensitivity: float = 0.1

@export_category("Physics")
@export var mass: float = 5

@export_category("debug")
@export var disable_shaders: bool = false
@export var show_extra_info: bool = false
@export var enable_fly: bool = false
@export var enable_inifite_stamina: bool = false
@export var enable_quick_reset: bool = false

@export_category("Properties")
@export var max_stamina: float = 10


var current_stamina: float = max_stamina:
	set(new_stamina):
		current_stamina = new_stamina
		if current_stamina > max_stamina:
			current_stamina = max_stamina

var input_dir: Vector2
var direction: Vector3
var prev_dir: Vector3

var is_on_ground: bool = false

var enabled_gravity: bool = true

var current_speed: float = 0



@onready var state_machine: StateMachine = %StateMachine
@onready var head: Node3D = $Head
@onready var ground_cast: RayCast3D = $GroundCast

@onready var debug_info_container: VBoxContainer = %DebugInfoContainer
@onready var debug_info: Dictionary = {
	"CurrentState": "null",
	"PreviousState": "null",
	"CurrentSpeed": "null",
	"CurrentStamina": "null"
}

func _ready() -> void:
	if show_extra_info:
		for key: String in debug_info.keys():
			var debug_label: Label = Label.new()
			debug_label.name = key
			debug_label.text = key + str(debug_info[key])
			debug_info_container.add_child(debug_label)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity
		head.rotation_degrees.x -= event.relative.y * sensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -80, 80)
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("mouse_left"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("debug_reset") and enable_quick_reset:
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if input_dir != Vector2.ZERO:
		prev_dir = direction

	if not is_on_ground and enabled_gravity:
		velocity += get_gravity() * delta * mass


func _process(_delta: float) -> void:
	is_on_ground = ground_cast.is_colliding()
	
	debug_info = {
		"CurrentState": state_machine.get_current_state_name(),
		"PreviousState": state_machine.get_previous_state_name(),
		"CurrentSpeed": str(current_speed),
		"CurrentStamina": str(current_stamina)
	}
	
	for debug_label: Label in debug_info_container.get_children():
		debug_label.text = debug_label.name + ": " + debug_info[debug_label.name]

func kill() -> void:
	pass
