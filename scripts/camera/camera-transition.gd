extends Camera2D

##
##	This script handles all the camera transitioning
##	Screen MUST match the room grid size, The camera must NEVER
##	be a child or parent of anything that moves. 
##	
##	Transitioning acts as the end all be all stopper for moving the camera
##	it is only touched here and inside room-manager(RM), RM set's it true before
##	teleporting the player but it is flipped here.
##	
##	NUDGE is used to move the player slightly after a transition, not level
##	change, so they don't retrigger the room transition.
##

#Constants
const SCREEN 			= Vector2(160,144)
const TRANSITION_TIME 	= 0.4 #seconds
const NUDGE				= 10 #pixels

#State
var current_cell 		= Vector2i(0,0)
var transitioning 		: bool = false
var tween				: Tween

@export var player		: CharacterBody2D

func _ready() -> void:
	if not player:
		if not get_tree().get_first_node_in_group("Player"):
			push_error("Unable to find player")
			return
		else:
			player = get_tree().get_first_node_in_group("Player")
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	current_cell = floor(player.global_position / SCREEN)
	global_position = current_cell * SCREEN
	
	
func _physics_process(delta: float) -> void:
	if not player or transitioning: return
	
	var new_cell = floor(player.global_position / SCREEN)
	if new_cell != current_cell:
		_transition_camera(new_cell)

## 
##	Transitions the camera in the same level to a different cell 
##	current cell updates before tween finishes for smooth transition,
##	NUDGE moves player so they don't retirgger transition.
##
func _transition_camera(new_cell) -> void:
	transitioning = true
	player.can_move = false
	var direction = new_cell - current_cell
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_cell * SCREEN, TRANSITION_TIME)
	current_cell = new_cell
	await tween.finished
	player.global_position += direction * NUDGE
	player.can_move = true
	transitioning = false
	
##
##	Room manager should be the only enityt calling this function
##	this assumes MainStuff exist if it doesn't this should never trigger
##	transition will be true when this is called, RM handles that.
##	The tween is tied with the tween in RM
##
func room_slide(direction : Vector2) -> void:
	if tween and tween.is_valid():
		tween.kill()
		print("Killed tween")
	current_cell = floor(player.global_position / SCREEN)
	var rest = current_cell * SCREEN
	var nPos = rest - direction * SCREEN
	global_position = nPos
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", rest, TRANSITION_TIME)
	await tween.finished
	transitioning = false
