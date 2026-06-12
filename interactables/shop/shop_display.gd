extends Node3D

class_name ShopDisplay

@export var item: Item
@export var initial_amount: int

var offset: float = 0.1
var rotation_speed: float = 2

var sending: Array[Array]


func _ready() -> void:
	for i in range(initial_amount):
		var model: Node3D = item.model.instantiate()

		add_child(model)
		model.position += Vector3(0, -offset, offset) * i


func _process(delta: float) -> void:
	for child: Node3D in get_children():
		child.rotate(Vector3.ONE.normalized(), rotation_speed * delta)

	if sending.is_empty():
		return

	for to_send: Array in sending:
		var node: Node3D = to_send[0]
		var target: Hand = to_send[1]

		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(node, "global_position", target.global_position, 0.07)

		if (node.global_position - target.global_position).length() < 0.5:
			var qf_tween: Tween = get_tree().create_tween()
			qf_tween.tween_property(node, "scale", Vector3.ZERO, 0.1)

		if (node.scale - Vector3.ZERO).length() <= 0.2:
			sending.erase(to_send)
			node.call_deferred("queue_free")


func send(hand: Hand) -> void:
	var to_send: Node3D = get_children()[-1]
	for is_sending: Array in sending:
		if to_send == is_sending[0]:
			push_error("Attempted to send an item currently sending")

	self.move_child(to_send, 0)
	sending.append([to_send, hand])


func recieve() -> void:
	pass
