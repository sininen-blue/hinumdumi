extends Node3D

class_name ShopDisplay

@export var item: Item
@export var initial_amount: int

var current_amount: int = 0
var offset: float = 0.1
var rotation_speed: float = 2
var item_move_speed: float = 0.1

var sending: Array[Array]
var recieving: Array[Array]


func _ready() -> void:
	var label: Label3D = Label3D.new()
	label.text = item.name
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)
	label.position.y += 0.5

	current_amount = initial_amount

	for i in range(initial_amount):
		var model: Node3D = item.model.instantiate()

		add_child(model)
		model.position += Vector3(0, -offset, offset) * i


func _process(delta: float) -> void:
	for child: Node3D in get_children():
		child.rotate(Vector3.ONE.normalized(), rotation_speed * delta)

	if sending.is_empty() != true:
		for to_send: Array in sending:
			var node: Node3D = to_send[0]
			var target: Hand = to_send[1]

			var reached: bool = _move_to_node(node, target)
			var shrunk: bool = false

			if reached:
				shrunk = _shrink(node)

			if shrunk:
				node.call_deferred("queue_free")
				sending.erase(to_send)

	if recieving.is_empty() != true:
		for to_recieve: Array in recieving:
			var node: Node3D = to_recieve[0]
			var target: Vector3 = to_recieve[1]

			var reached: bool = _move_to_target(node, target)
			if reached:
				recieving.erase(to_recieve)


func send(hand: Hand) -> void:
	current_amount -= 1

	var to_send: Node3D = get_children()[-1]
	for is_sending: Array in sending:
		if to_send == is_sending[0]:
			push_error("Attempted to send an item currently sending")

	self.move_child(to_send, 0)
	sending.append([to_send, hand])


func recieve(hand: Hand) -> void:
	var to_recieve: Node3D = item.model.instantiate()

	add_child(to_recieve)
	to_recieve.global_position = hand.global_position
	var target: Vector3 = self.global_position + Vector3(0, -offset, offset) * (current_amount - 1)

	recieving.append([to_recieve, target])

	current_amount += 1


func _move_to_node(node: Node3D, target: Node3D) -> bool:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "global_position", target.global_position, item_move_speed)

	if (node.global_position - target.global_position).length() < 0.5:
		return true

	return false


func _move_to_target(node: Node3D, target: Vector3) -> bool:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "global_position", target, item_move_speed)

	if (node.global_position - target).length() < 0.1:
		return true

	return false


func _shrink(node: Node3D) -> bool:
	var qf_tween: Tween = get_tree().create_tween()
	qf_tween.tween_property(node, "scale", Vector3.ZERO, 0.1)

	if (node.scale - Vector3.ZERO).length() <= 0.2:
		return true

	return false
