class_name Interactable

extends RigidBody2D

@export var interact_name: String = ""
@export var is_interactable: bool = true

func _init():
	gravity_scale = 0.0	
	z_index = 3
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)

var interact: Callable = func():
	pass
