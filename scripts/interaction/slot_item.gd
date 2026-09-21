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
func _process(delta: float) -> void:
	if itemReadyToBeInteracted:
		_reEnableInteraction()

func _reEnableInteraction():
	if self.linear_velocity.is_zero_approx():
		if item_data.is_reusable:
			if self.is_interactable == false:
				self.is_interactable = true
		else:
			if item_data.has_been_thrown == true:
				animPlayer.play("dispose")
				await animPlayer.animation_finished
				queue_free()

func _thrownItemReady():
	itemReadyToBeInteracted = true

func HandleEquippedToSlot():
	pass

func _on_interact(player_input):
	if player_input == GB_GLOBALS.BtnInput.A:
		PlayerInventoryGlobal.TryEquipSlotA(self)
		queue_free()
	elif player_input == GB_GLOBALS.BtnInput.B:
		PlayerInventoryGlobal.TryEquipSlotB(self)
		queue_free()
	else:
		print("Unhandled input triggered in slot_item _on_interact.")
