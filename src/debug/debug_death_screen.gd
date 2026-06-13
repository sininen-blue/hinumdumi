extends Control

const MAIN_MENU: PackedScene = preload("res://ui/main_menu/main_menu.tscn")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	SceneManager.change_scene(MAIN_MENU)
