extends Interactable

class_name SlotItem

@export var item_data: ItemData
@onready var animPlayer: AnimatedSprite2D = $AnimatedSprite2D
var itemReadyToBeInteracted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_data = item_data.duplicate()
	interact = _on_interact
	get_tree().create_timer(0.5).timeout.connect(_thrownItemReady)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if itemReadyToBeInteracted:
		_reEnableInteraction()

func _reEnableInteraction():
	# If, for some reason this runs while the item is still moving, do nothing.
	if not self.linear_velocity.is_zero_approx():
		return
	
	itemReadyToBeInteracted = false
	
	if item_data.is_reusable:
		self.is_interactable = true
		return
	
	# Handle Single-Use Thrown Items (like Bombs, but could be extended to other stuff)
	if item_data.has_been_thrown == true:
		animPlayer.play("dispose")
		await animPlayer.animation_finished
		if item_data.item_name == "bomb":
			await get_tree().physics_frame
			inflictExplosionDamamge()
		queue_free()

func _thrownItemReady():
	itemReadyToBeInteracted = true

func HandleEquippedToSlot():
	pass

func inflictExplosionDamamge():
	var bodies = $DamageRange.get_overlapping_bodies()
	for body in bodies:
		print("Body = ", body.name)
		var found : Array[Node] = body.find_children("*", "Health", true, false)
		if not found.is_empty():
			for item in found:
				print("item.name = ", item.name)
				item.take_damage(1)

func _on_interact(player_input):
	if player_input == GB_GLOBALS.BtnInput.A:
		PlayerInventoryGlobal.TryEquipSlotA(self)
		queue_free()
	elif player_input == GB_GLOBALS.BtnInput.B:
		PlayerInventoryGlobal.TryEquipSlotB(self)
		queue_free()
	else:
		print("Unhandled input triggered in slot_item _on_interact.")
