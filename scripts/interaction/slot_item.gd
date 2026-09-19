extends Interactable

class_name SlotItem

@export var item_data: ItemData

@onready var playerInventory: PlayerInventory = $"../Inventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_data = item_data.duplicate()
	interact = _on_interact

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func HandleEquippedToSlot():
	pass

func _on_interact(player_input):
	print(player_input)
	if player_input == GB_GLOBALS.BtnInput.A:
		playerInventory.playerTryEquipSlotA(self)
	elif player_input == GB_GLOBALS.BtnInput.B:
		playerInventory.playerTryEquipSlotB(self)
	else:
		print("Unhandled input triggered in slot_item _on_interact.")
