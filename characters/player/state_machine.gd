extends StateMachine


func headbob(time: float, freq: float, strength: float) -> Vector3:
	var headbob_position: Vector3 = Vector3.ZERO
	headbob_position.y = sin(time * freq) * strength
	headbob_position.x = cos(time * freq / 3) * strength
	return headbob_position
