extends Area2D
class_name Arrow

const SPEED := 100.0
var _dir : Vector2

# how long the arrow lives
var life := 3.0

var direction : GB_GLOBALS.FaceDirection
var damage : int

func _ready() -> void:
	_dir = _convert_direction()
	body_entered.connect(_hit)
	
func _physics_process(delta: float) -> void:
	position += _dir * SPEED * delta
	life -= delta
	if life <= 0:
		queue_free()

func _hit(body : Node2D) -> void:
	if body.is_in_group("Player"):
		body.healthComponent.take_damage(damage)
	
	queue_free()

func _convert_direction() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	match direction:
		GB_GLOBALS.FaceDirection.up:
			dir = Vector2.UP
		GB_GLOBALS.FaceDirection.down:
			dir = Vector2.DOWN
		GB_GLOBALS.FaceDirection.right:
			dir = Vector2.RIGHT
		GB_GLOBALS.FaceDirection.left:
			dir = Vector2.LEFT
	
	return dir
