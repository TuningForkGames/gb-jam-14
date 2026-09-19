class_name Interactable
extends RigidBody2D

enum IType {
	none,
	consumable, 
	equipment, 
	throwable_light, 
	throwable_heavy 
}

@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var interactable_type: IType = IType.none

func _init():
	gravity_scale = 0.0

var interact: Callable = func():
	pass
