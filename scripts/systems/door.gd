extends Area2D
class_name Door

@export_file("*tscn") var target_room		: String
@export var target_entry					: String
@export var direction						: Vector2
@export var sprite 							: Texture2D

func _ready() -> void:
	$Sprite2D.texture = sprite
	self.body_entered.connect(door_entered)

func door_entered(body) -> void:
	if not body.is_in_group("Player"): return
	
	get_tree().get_first_node_in_group("RoomManager").transition_to(target_room, target_entry, direction)
