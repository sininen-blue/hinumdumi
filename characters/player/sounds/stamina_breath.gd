extends Node


@export var player: Player
@export var high_stam_threshold: float = 7.0
@export var med_stam_threshold: float = 5.0
@export var low_stam_threshold: float = 1.0

enum threshold {HIGH, MED, LOW, OUT, NULL}
var current_threshold: threshold = threshold.NULL
var current_sound: AudioStreamPlayer3D

@onready var breath: AudioStreamPlayer3D = $Breath
@onready var breath_timer: Timer = $Breath/Timer
@onready var high_stamina_breath: AudioStreamPlayer3D = $HighStaminaBreath
@onready var med_stamina_breath: AudioStreamPlayer3D = $MedStaminaBreath
@onready var low_staimina_breath: AudioStreamPlayer3D = $LowStaiminaBreath
@onready var out_of_stamina: AudioStreamPlayer3D = $OutOfStamina
@onready var empty_sound: AudioStreamPlayer3D = $EmptySound
@onready var state_machine: Node = %StateMachine


func _process(_delta: float) -> void:
	var stam: float = player.current_stamina
	
	if stam > high_stam_threshold and stam < player.max_stamina and current_threshold != threshold.HIGH:
		breath_timer.stop()
		current_threshold = threshold.HIGH
		_transition_to(high_stamina_breath)
	elif stam > med_stam_threshold and stam < high_stam_threshold and current_threshold != threshold.MED:
		breath_timer.stop()
		current_threshold = threshold.MED
		_transition_to(med_stamina_breath)
	elif stam > low_stam_threshold and stam < med_stam_threshold and current_threshold != threshold.LOW:
		breath_timer.stop()
		current_threshold = threshold.LOW
		_transition_to(low_staimina_breath)
	elif stam > 0 and stam < low_stam_threshold and current_threshold != threshold.OUT:
		breath_timer.stop()
		current_threshold = threshold.OUT
		_transition_to(out_of_stamina)
	elif stam >= player.max_stamina and current_threshold != threshold.NULL:
		current_threshold = threshold.NULL
		_transition_to(empty_sound)
		breath_timer.start(randf_range(1, 5))


func _transition_to(next_sound: AudioStreamPlayer3D):
	if current_sound == null:
		current_sound = next_sound
		current_sound.play()
		return
	
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(current_sound, "volume_db", -20, 1)
	tween.tween_property(next_sound, "volume_db", 0, 1)
	tween.play()
	
	current_sound.play()
	next_sound.play()
	
	await tween.finished
	current_sound.stop()
	current_sound = next_sound


func _on_timer_timeout() -> void:
	breath.play()
	breath_timer.start(randf_range(4, 8))
