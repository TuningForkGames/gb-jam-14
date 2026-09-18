class_name Interactable
extends Area2D

@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var weight:GB_GLOBALS.ItemWeight = GB_GLOBALS.ItemWeight.normal

var interact: Callable = func():
	pass
