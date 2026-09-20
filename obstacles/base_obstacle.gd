extends Node2D

var _player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug01")):
		pass
	pass


func _on_health_component_died() -> void:
	queue_free()
	pass # Replace with function body.
