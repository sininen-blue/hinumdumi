extends Label


@export var slider: HSlider


func _ready() -> void:
	slider.value_changed.connect(_on_slider_value_changed)


func _on_slider_value_changed(value: float) -> void:
	self.text = "%.2f" % value
