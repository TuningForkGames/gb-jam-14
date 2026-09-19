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

@export var item_name			: String
@export var frames				: SpriteFrames	# For non staic thigns like the coin.
@export var animation_name		: String		# name of animation to play if exist
@export var effect				: Effect		# enum can add for more as needed
@export var value				: int			# value to change anything by
@export var pickup_sfx			: AudioStream	# in case jake wants to add more sounds haha
@export var player_use_anim_name: String
@export var quantity			: int
@export var is_consumable 		: bool
@export var item_weight			: Weight = Weight.normal
