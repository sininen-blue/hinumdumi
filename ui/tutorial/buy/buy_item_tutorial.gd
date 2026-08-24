extends FadingTutorialText


func _process(delta: float) -> void:
	super._process(delta)
	if PlayerInventory.inventory.is_empty() == false:
		has_done_action = true
	


func _on_area_3d_body_entered(_body: Node3D) -> void:
	start_count()
