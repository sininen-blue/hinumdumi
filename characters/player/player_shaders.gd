extends CanvasLayer


@export var player: Player
@export var closeness_threshold: float = 50
@export var closeness_intensity: Curve

var max_stamina: float
var stamina: float
var stamina_normalized: float
var max_intensity: float = 0.8
var intensity: float = 0.0

var closeness: float = 9999
var closeness_normalized: float = 0

@onready var vignette: ShaderMaterial = %Vignette.material
@onready var detection_vignette: ColorRect = %DetectionVignette
@onready var detection_vignette_shader: ShaderMaterial = %DetectionVignette.material


func _ready() -> void:
	max_stamina = player.max_stamina
	stamina = player.current_stamina


func _process(_delta: float) -> void:
	stamina = player.current_stamina
	stamina_normalized = stamina/max_stamina
	
	intensity = (1 - stamina_normalized) * max_intensity
	vignette.set_shader_parameter("intensity", intensity)
	
	
	closeness = player.monster_closeness
	detection_vignette.visible = closeness < closeness_threshold
	closeness_normalized = closeness / closeness_threshold
	detection_vignette_shader.set_shader_parameter("intensity", closeness_intensity.sample(closeness_normalized))
	
