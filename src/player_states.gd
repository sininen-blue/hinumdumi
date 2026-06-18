extends Node

@export var left_home: bool = false
@export var first_buy: bool = false
@export var is_hiding: bool = false
@export var is_crouching: bool = false
@export var in_home: bool = false


func reset() -> void:
	left_home = false
	first_buy = false
	is_hiding = false
	is_crouching = false
	in_home = false
