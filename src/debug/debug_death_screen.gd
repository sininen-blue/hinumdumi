extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	PlayerInventory.reset()
	PlayerStates.reset()
	SceneManager.change_scene(load("res://levels/Demo/demo_level_1.tscn"))
