extends CanvasLayer


@export var player: Player


var max_stamina: float
var stamina: float
var stamina_normalized: float
var max_intensity: float = 0.8
var intensity: float = 0.0


@onready var vignette: ShaderMaterial = %Vignette.material


func _ready() -> void:
	max_stamina = player.max_stamina
	stamina = player.current_stamina


func _process(_delta: float) -> void:
	stamina = player.current_stamina
	stamina_normalized = stamina/max_stamina
	
	intensity = (1 - stamina_normalized) * max_intensity
	vignette.set_shader_parameter("intensity", intensity)
