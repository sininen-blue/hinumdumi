extends Node3D
class_name PlayerEvent

@export var debug: bool = false
@export var detector: PlayerDetector
@export_range(0, 1, 0.05, "suffix:%") var chance: float = 0.5
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var cooldown: float = 10.0

var time_left: float = 0
var debug_label: Label3D


func _ready() -> void:
	if debug:
		debug_label = Label3D.new()
		debug_label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		add_child(debug_label)
	
	detector.detected_player.connect(_on_detector_detected_player)


func _process(delta: float) -> void:
	if debug:
		debug_label.text = "cooldown: %.2f" % time_left
	
	if time_left > 0:
		time_left -= 1 * delta


func run_event(_player: Player) -> void:
	pass


func _on_detector_detected_player(player: Player) -> void:
	if randf() > chance:
		return
	if time_left > 0:
		return
	
	time_left = cooldown
	run_event(player)
