extends Sprite2D


func _ready() -> void:
	self.visible = false
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color("#ffffff00"), 1)
	
	$AnimationPlayer.play("play")


func toggle() -> void:
	var tween: Tween = get_tree().create_tween()
	
	if self.visible == false:
		self.visible = true
		tween.tween_property(self, "self_modulate", Color("#ffffff"), 1)
	else:
		tween.tween_property(self, "self_modulate", Color("#ffffff00"), 1)
		tween.tween_callback(self.unshow)


func unshow() -> void:
	self.visible = false
