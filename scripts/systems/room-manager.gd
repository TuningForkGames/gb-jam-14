extends Node
class_name RoomManager

##
##	Ownes all rooms, makes them childern of this node, placed at origin.
##	Never parent/child this to MainStuff this should never be parneted to a room.
##	When it deletes a room it should only remove that tscn.
##	Use "Spawn" for loading the FIRST level and use another name for moving to 
##	new scenes after the first.
##

#this will hold the path to the first room
@export_file("*.tscn") var start_room_path = "res://levels/World1_1.tscn"

var bTransitioning : bool = false
var player : CharacterBody2D
var current_room : Node2D

@onready var SlideOverlay : TextureRect = $"../Overlay/SlideOverlay"
@onready var Camera : Camera2D = $"../Camera2D"

func _ready() -> void:	
	player = get_tree().get_first_node_in_group("Player")
	if not player: 
		push_error("Player was null")
		return
		
	if player is not Player:
		push_error("Player node is missing player.gd")
		return
	
	if not Camera:
		push_error("Camera not loaded")
		return
	else:
		if not Camera.has_method("room_slide"):
			push_error("Camera is missing script")
			return
	
	await load_room(start_room_path, "Spawn")
	
	if not current_room:
		push_error("Error loading current level.")
		return

##
##	Loads the new room and moves player to the Marker2D location
##	Returns false on failure so the game doesn't crash
##	player will be stuck in current cell/level though
##
func load_room(path : String, entry_name : String) -> bool:
	if not ResourceLoader.exists(path):
		push_error("Path var is invalid please check it: %s" % path)
		return false
		
	var old_room = current_room
	current_room = load(path).instantiate()
	add_child.call_deferred(current_room)
	await get_tree().physics_frame
	if old_room:
		old_room.queue_free()
	#player.global_position = _get_spawn_loc(entry_name)
		
	return true


##
##	Takes a screenshot of the current area, then uses that to fake the 
##	movement to a new cell uses a non awaited tween in tandom with the one
##	in the camera transition script.
##	after all is done will prune the collectables or any other things we don't 
##	wnat to repop.
##


func transition_to(path : String, entry_name : String, direction : Vector2) -> void:
	if bTransitioning: return
	
	bTransitioning = true
	Camera.transitioning = true
	player.can_move = false
	await RenderingServer.frame_post_draw
	var capture : Image = get_viewport().get_texture().get_image()
	var tex := ImageTexture.create_from_image(capture)
	SlideOverlay.texture = tex
	SlideOverlay.position = Vector2.ZERO
	SlideOverlay.show()
	player.hide()
	if await load_room(path, entry_name):
		_prune_collected()
		var tween = get_tree().create_tween()
		tween.tween_property(SlideOverlay, "position", -direction * Camera.SCREEN, Camera.TRANSITION_TIME)
		await Camera.room_slide(direction)
		SlideOverlay.hide()
		player.show()
		bTransitioning = false
		player.can_move = true
	else:
		push_error("Issue with load_room")
		SlideOverlay.hide()
		player.show()
		Camera.transitioning = false
		bTransitioning = false
		player.can_move = true
		return

##
##	Made this when I was calling it more than once, just returns the spawn point
##	or sets it to 10,10 chould update to just spawn center of the new map.
##
func _get_spawn_loc(entry_name : String) -> Vector2:
	var entry_marker : Marker2D = current_room.get_node_or_null(entry_name)
	var spawn : Vector2
	if is_instance_valid(entry_marker):
		spawn = entry_marker.global_position
	else:
		push_error("Entry Marker not found for ", current_room)
		spawn = Vector2(10,10)
	return spawn

## TODO ##
##
##	Need to figure out how we wanna handle non respawnable entites.
##
func _prune_collected() -> void:
	pass
