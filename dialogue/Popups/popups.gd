extends Control

func _ready() -> void:
	self.visible = false

func toggle() -> void:
	self.visible = !self.visible
