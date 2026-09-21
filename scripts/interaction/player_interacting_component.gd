extends Node2D

@export var interactAreaSize: Vector2 = Vector2(10, 10)
@export var interactNudgeDistance: float = 16

@onready var interact_label: Label = $InteractLabel

var current_interactions := []
var can_interact := true

var hold_timer: float = 0.0
@export var hold_threshold: float = 0.3
var is_tracking: bool = false

func _ready() -> void:
	%InteractArea.shape.size = interactAreaSize

func _process(delta: float) -> void:
	_handleActionInput(delta)
		
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sortByNearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()

func _handleActionInput(delta):
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
					_throwItem(PlayerInventoryGlobal.Slot_A.prefab_path, GB_GLOBALS.BtnInput.A)
		# A Tap Logic
		elif Input.is_action_just_released("a_btn"):
			if hold_timer <= hold_threshold:
				print("A tap detected")
				is_tracking = false
				hold_timer = 0.0
				if PlayerInventoryGlobal.IsSlotAFree():
					_callInteraction(GB_GLOBALS.BtnInput.A)
				else:
					if PlayerInventoryGlobal.Slot_A.item_name == "sword":
						get_parent().attack()
					else:
						_throwItem(PlayerInventoryGlobal.Slot_A.prefab_path, GB_GLOBALS.BtnInput.A)
					print("use A item")
		# B Hold Logic 
		if Input.is_action_pressed("b_btn"):
			hold_timer += delta
			if hold_timer >= hold_threshold:
				print("B hold detected")
				is_tracking = false 
				if !PlayerInventoryGlobal.IsSlotBFree():
					print("throw B item")
					_throwItem(PlayerInventoryGlobal.Slot_B.prefab_path, GB_GLOBALS.BtnInput.B)
		# B Tap Logic
		elif Input.is_action_just_released("b_btn"):
			if hold_timer <= hold_threshold:			
				print("B tap detected")
				is_tracking = false
				hold_timer = 0.0
				if PlayerInventoryGlobal.IsSlotBFree():
					_callInteraction(GB_GLOBALS.BtnInput.B)
				else:
					if PlayerInventoryGlobal.Slot_B.item_name == "sword":
						get_parent().attack()
					else:
						_throwItem(PlayerInventoryGlobal.Slot_B.prefab_path, GB_GLOBALS.BtnInput.B)
					print("use B item")

func _callInteraction(input):
	if current_interactions:
		if can_interact:		
			can_interact = false
			interact_label.hide()
			await  current_interactions[0].interact.call(input)
		can_interact = true

func _throwItem(prefab_path, slot):
	if slot == GB_GLOBALS.BtnInput.A:
		PlayerInventoryGlobal.Slot_A = null
	elif slot == GB_GLOBALS.BtnInput.B:
		PlayerInventoryGlobal.Slot_B = null
	else:
		print("slot unhandled")
	print(prefab_path)
	if (prefab_path != ""):
		var packed_scene = load(prefab_path) as PackedScene
		if packed_scene:
			var _throwItem:SlotItem = packed_scene.instantiate() as SlotItem
			get_tree().current_scene.add_child(_throwItem)
			var _playerCurrPos = get_parent().global_position
			var _spawnPos = _playerCurrPos + (get_parent().getPlayerFaceVector() * 12.0)
			_throwItem.global_position = Vector2(_spawnPos)
			_throwItem.freeze = false
			print(_throwItem.linear_damp)
			_throwItem.apply_central_impulse(get_parent().getPlayerFaceVector() * 200.0)
			_throwItem.is_interactable = false
			_throwItem.item_data.has_been_thrown = true

func updateInteractDirection(facingDirection: Vector2) -> void:
	# Avoid shifting if the player isn't moving/pressing a direction
	if facingDirection == Vector2.ZERO:
		return
		
	# Normalize and apply the nudge offset relative to the player
	position = facingDirection.normalized() * interactNudgeDistance

func _sortByNearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_body_exited(body: Node2D) -> void:
	current_interactions.erase(body)

func _on_interact_range_body_entered(body: Node2D) -> void:
	current_interactions.push_back(body)
