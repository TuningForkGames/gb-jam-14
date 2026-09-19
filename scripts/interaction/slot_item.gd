extends Interactable

class_name SlotItem

@export var item_data			: ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_data = item_data.duplicate()
	interact = _on_interact

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func HandleEquippedToSlot():
	pass

func _on_interact():
	queue_free()
