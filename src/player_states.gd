extends Node

@export var has_talked_to_parent: bool = false
@export var left_home: bool = false
@export var first_buy: bool = false
@export var is_hiding: bool = false
@export var is_crouching: bool = false
@export var in_home: bool = false

@export var has_moved: bool = false
@export var has_sprinted: bool = false


func reset() -> void:
	has_talked_to_parent = false
	left_home = false
	first_buy = false
	is_hiding = false
	is_crouching = false
	in_home = false
	
	has_moved = false
	has_sprinted = false
