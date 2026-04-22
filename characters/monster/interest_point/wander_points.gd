extends Node3D
class_name WanderPoints

@onready var points: Array[InterestPoint]

func _ready() -> void:
	var children: Array[Node] = self.get_children()
	
	for child: Node in children:
		if child is InterestPoint:
			points.append(child)
