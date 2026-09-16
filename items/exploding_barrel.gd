extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	interactable.interact = _on_interact

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interact():
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		interactable.is_interactable = false
		print("interacted with exploding barrel")
