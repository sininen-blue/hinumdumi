extends Label3D

@export var state_machine: StateMachine


func _process(_delta: float) -> void:
	self.text = str(state_machine.current_state.name)
