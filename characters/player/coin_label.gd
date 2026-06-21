extends Label3D

func _process(_delta: float) -> void:
	self.text = str(int(PlayerInventory.money))
