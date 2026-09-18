class_name Interactable
extends Area2D

@export var interact_name: String = ""
@export var is_interactable: bool = true
enum weight {light, normal, heavy}
@export var interactable_weight:weight = weight.normal

var interact: Callable = func():
	pass
