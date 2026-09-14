extends Camera2D

#Constants
const  SCREEN 			= Vector2(160,144)
const TRANSITION_TIME 	= 0.4 #seconds
const NUDGE				= 10 #pixels

#State
var current_cell 		= Vector2i(0,0)
var transitioning 		: bool = false

@export var player		: CharacterBody2D
@export var playerNode	: Node2D

func _ready() -> void:
	player = playerNode.get_child(1)
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	current_cell = floor(player.global_position / SCREEN)
	global_position = current_cell * SCREEN
	
	
func _physics_process(delta: float) -> void:
	if not player or transitioning: return
	
	var new_cell = floor(player.global_position / SCREEN)
	if new_cell != current_cell:
		_transition_camera(new_cell)

func _transition_camera(new_cell) -> void:
	transitioning = true
	player.can_move = false
	var direction = new_cell - current_cell
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_cell * SCREEN, TRANSITION_TIME)
	current_cell = new_cell
	await tween.finished
	player.global_position += direction * NUDGE
	player.can_move = true
	transitioning = false
