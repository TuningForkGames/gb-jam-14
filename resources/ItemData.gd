extends Resource
class_name ItemData

enum Effect{
	Heal,
	Currency,
	Key_Item,
	Quest_Item
}

enum Weight{
	normal,
	light,
	heavy
}

enum ItemType{
	
}

@export var item_name			: String
@export var item_weight			: Weight = Weight.normal
@export var quantity			: int
@export var is_consumable 		: bool
@export_file("*.tscn") var prefab_path: String

@export var player_use_anim_name: String

#unsure if needed
@export var frames				: SpriteFrames
@export var animation_name		: String
@export var effect				: Effect
@export var value				: int
@export var pickup_sfx			: AudioStream
