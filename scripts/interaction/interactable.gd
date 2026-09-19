class_name Interactable

extends RigidBody2D

@export var interact_name: String = ""
@export var is_interactable: bool = true

func _init():
	gravity_scale = 0.0

var interact: Callable = func():
	pass
