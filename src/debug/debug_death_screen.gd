extends Control

@onready var restart_game: Button = $RestartGame
@onready var restart_level: Button = $RestartLevel


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_restart_game_pressed() -> void:
	restart_game.disabled = true
	PlayerInventory.reset()
	PlayerStates.reset()
	SceneManager.change_scene(load("res://ui/main_menu/main_menu.tscn"))


func _on_restart_level_pressed() -> void:
	restart_level.disabled = true
	PlayerInventory.reset()
	PlayerStates.reset()
	SceneManager.change_scene(load("res://levels/Demo/demo_level_1.tscn"))
