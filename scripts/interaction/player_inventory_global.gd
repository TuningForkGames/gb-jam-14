extends Node

var Slot_A: ItemData = null
var Slot_B: ItemData = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func TryEquipSlotA (_slotItem: SlotItem) -> bool:
	if not IsSlotAFree():
		return false
		
	Slot_A = _slotItem.item_data.duplicate()
	#Slot_A.HandleEquippedToSlot()
	return true
	
func TryEquipSlotB (_slotItem: SlotItem) -> bool:
	if not IsSlotBFree():
		return false
		
	Slot_B = _slotItem.item_data.duplicate()
	#Slot_B.HandleEquippedToSlot()
	return true

func IsSlotAFree() -> bool:
	return Slot_A == null
	
func IsSlotBFree() -> bool:
	return Slot_B == null
