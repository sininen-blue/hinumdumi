extends Area3D


const DEMO_LEVEL_1 = preload("uid://bwd570eivx0mj")


func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	PlayerInventory.reset()
	PlayerStates.reset()
	SceneManager.change_scene(DEMO_LEVEL_1, true, 1, 2)
