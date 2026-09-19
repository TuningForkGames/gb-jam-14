extends Area2D

@onready var interactable: Interactable = $Interactable
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _player

func _ready() -> void:
	interactable.interact = _on_interact
	#self.interactable_type =
	_player = get_tree().current_scene.find_child("Player", true, false)

func _on_interact():
	self.reparent(_player)
	self.position = Vector2(0,-14)
	self.z_index = 3
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		interactable.is_interactable = false
		print("interacted with exploding barrel")
