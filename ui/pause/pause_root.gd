extends Control


@export var debug: bool = false
@export var player: Player


var config: ConfigFile = ConfigFile.new()
var path: String = "user://settings.cfg"


@onready var master_slider: HSlider = $Panel/VBoxContainer/Master/MasterSlider
@onready var music_label: HSlider = $Panel/VBoxContainer/Music/MusicLabel
@onready var sfx_slider: HSlider = $Panel/VBoxContainer/SFX/SFXSlider
@onready var resolution_slider: HSlider = $Panel/VBoxContainer/ResolutionsScale/ResolutionSlider
@onready var fullscreen_toggle: CheckButton = $Panel/VBoxContainer/Fullscreen/FullscreenToggle
@onready var mouse_sens_slider: HSlider = $Panel/VBoxContainer/MouseSensitivity/MouseSensSlider
@onready var pan_slider: HSlider = $Panel/VBoxContainer/PanSensitivity/PanSlider


func _ready() -> void:
	load_settings()
	
	if debug:
		show_settings()
	hide_settings()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if self.visible == true:
			hide_settings()
		else:
			show_settings()


func show_settings() -> void:
	get_tree().paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func hide_settings() -> void:
	get_tree().paused = false
	self.visible = false


func load_settings() -> void:
	var err := config.load(path)
	if err == ERR_FILE_NOT_FOUND:
		printerr("Could not load settings.cfg")
		load_defaults()
	
	master_slider.value = config.get_value("audio", "master", 100)
	music_label.value = config.get_value("audio", "music", 100)
	sfx_slider.value = config.get_value("audio", "sfx", 100)
	
	resolution_slider.value = config.get_value("video", "resolution_scale", 100)
	fullscreen_toggle.button_pressed = config.get_value("video", "fullscreen", true)
	
	mouse_sens_slider.value = config.get_value("controls", "mouse_sensitivity", 0.1)
	pan_slider.value = config.get_value("controls", "joystick_sensitivity", 100)
	
	config.save(path)


func load_defaults() -> void:
	config.set_value("audio", "master", 100)
	config.set_value("audio", "music", 100)
	config.set_value("audio", "sfx", 100)
	
	config.set_value("video", "resolution_scale", 100)
	config.set_value("video", "fullscreen", true)
	
	config.set_value("controls", "mouse_sensitivity", 0.1)
	config.set_value("controls", "joystick_sensitivity", 100)
	
	config.save(path)


func _on_ok_button_pressed() -> void:
	self.hide_settings()
	config.save(path)


func _on_reset_button_pressed() -> void:
	self.load_defaults()
	self.load_settings()


func _on_master_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus, value/100)
	
	config.set_value("audio", "master", value)
	config.save(path)


func _on_music_label_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus, value/100)
	
	config.set_value("audio", "music", value)
	config.save(path)


func _on_sfx_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_linear(bus, value/100)
	
	config.set_value("audio", "sfx", value)
	config.save(path)


func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	config.set_value("video", "fullscreen", toggled_on)
	config.save(path)


func _on_resolution_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value / 100
	
	config.set_value("video", "resolution_scale", value)
	config.save(path)


func _on_mouse_sens_slider_value_changed(value: float) -> void:
	if player == null:
		return
	player.sensitivity = value
	
	config.set_value("controls", "mouse_sensitivity", value)
	config.save(path)


func _on_pan_slider_value_changed(value: float) -> void:
	if player == null:
		return
	player.pan_sensitivity = value
	
	config.set_value("controls", "joystick_sensitivity", value)
	config.save(path)
