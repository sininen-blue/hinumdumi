extends Control

# assumes a structure of
# popups -> subviewportcontainer -> subviewport

func _ready() -> void:
	self.visible = false
	
	for child: SubViewportContainer in get_children():
		child.visible = false
		
		var node_children: Array[Node] = child.get_child(0).get_children()
		for node_child: Node in node_children:
			if node_child.name != "AnimationPlayer":
				node_child.visible = false

func toggle(target: String) -> void:
	self.visible = !self.visible
	
	var node: SubViewportContainer =  self.find_child(target)
	node.visible = !node.visible
	
	var node_children: Array[Node] = node.get_child(0).get_children()
	for child: Node in node_children:
		if child.name != "AnimationPlayer":
			child.visible = !child.visible
