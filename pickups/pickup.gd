# Pickup.gd
extends Area2D
class_name Pickup

@export var itemName: String = "Item Name"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	apply_effect(body)
	play_gather_animation()

func apply_effect(player: Node2D) -> void:
	# Override this function at the child scene level to customize based on pickup type.
	pass

func play_gather_animation() -> void:
	# Override this function at the child scene level to customize based on pickup type.
	# Standard functionlity is that the item will just disappear.
	queue_free() 
