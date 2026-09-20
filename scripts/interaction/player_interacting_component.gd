extends Node2D

@export var interactAreaSize: Vector2 = Vector2(10, 10)
@export var interactNudgeDistance: float = 16

@onready var interact_label: Label = $InteractLabel

var current_interactions := []
var can_interact := true

var hold_timer: float = 0.0
@export var hold_threshold: float = 0.3
var is_tracking: bool = false

var _currAItem
var _currBItem

func _ready() -> void:
	%InteractArea.shape.size = interactAreaSize

func _input(event: InputEvent) -> void:	
	pass

func _process(delta: float) -> void:
	_handle_action_input(delta)
		
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()

func _handle_action_input(delta):
	if Input.is_action_just_pressed("a_btn") || Input.is_action_just_pressed("b_btn"):
		is_tracking = true
		hold_timer = 0.0
	if is_tracking:
		# A Hold Logic
		if Input.is_action_pressed("a_btn"):
			hold_timer += delta
			if hold_timer >= hold_threshold:
				print("A hold detected")
				is_tracking = false
				if !PlayerInventoryGlobal.IsSlotAFree():
					print("throw A item")
					_currAItem = PlayerInventoryGlobal.Slot_A.item_prefab.instantiate()
					get_tree().root.add_child(_currAItem)
					var _playerCurrPos:Vector2 = get_parent().global_position
					_currAItem.global_position = Vector2(_playerCurrPos)
		# A Tap Logic
		elif Input.is_action_just_released("a_btn"):
			if hold_timer <= hold_threshold:
				print("A tap detected")
				is_tracking = false
				hold_timer = 0.0
				if PlayerInventoryGlobal.IsSlotAFree():
					_call_interaction(GB_GLOBALS.BtnInput.A)
				else:
					#for player directions
						#Player.animation.play(animation based on item)
					print("use A item")
		# B Hold Logic 
		if Input.is_action_pressed("b_btn"):
			hold_timer += delta
			if hold_timer >= hold_threshold:
				print("B hold detected")
				is_tracking = false 
				if !PlayerInventoryGlobal.IsSlotBFree():
					print("throw B item")
		# B Tap Logic
		elif Input.is_action_just_released("b_btn"):
			if hold_timer <= hold_threshold:			
				print("B tap detected")
				is_tracking = false
				hold_timer = 0.0
				if PlayerInventoryGlobal.IsSlotBFree():
					_call_interaction(GB_GLOBALS.BtnInput.B)
				else:
					#for player directions
						#Player.animation.play(animation based on item)
					print("use B item")

func _call_interaction(input):
	if current_interactions:
		if can_interact:		
			can_interact = false
			interact_label.hide()
			await  current_interactions[0].interact.call(input)
		can_interact = true



func updateInteractDirection(facingDirection: Vector2) -> void:
	# Avoid shifting if the player isn't moving/pressing a direction
	if facingDirection == Vector2.ZERO:
		return
		
	# Normalize and apply the nudge offset relative to the player
	position = facingDirection.normalized() * interactNudgeDistance

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_body_exited(body: Node2D) -> void:
	current_interactions.erase(body)

func _on_interact_range_body_entered(body: Node2D) -> void:
	current_interactions.push_back(body)
