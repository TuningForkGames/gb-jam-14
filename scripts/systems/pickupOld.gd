extends Area2D

@export var item_data			: ItemData

func _ready() -> void:
	if not item_data :
		push_error("You need to set item data in the inspector. Pickup needing item data is ", name)
		return
	setup_animation_sprite()
	body_entered.connect(pickup_item)
	
func pickup_item(body) -> void:
	if body.is_in_group("Player"):
		match item_data.effect:
			item_data.Effect.Heal:
				##Call body.heal() will update if player changes
				print("Heal player")
			item_data.Effect.Currency:
				##Call w/e handles moneies
				print("Add ", item_data.value, " to players moneis")
			item_data.Effect.Key_Item:
				##Call w/e handles key items
				print("Switch w/e needed for key items")
			item_data.Effect.Quest_Item:
				##Call w/e handles quest items
				print("IDK if we need this just threw it in here")
			_:
				push_error("Item Data has a null effect")
				return
		#play pickup sound if we do that, hide and disable item then free it
		self.hide()
		$CollisionShape2D.set_deferred("disabled",true)
		if item_data.pickup_sfx:
			await handle_audio()
		queue_free()
	else:
		print("body == ", body, " and isn't in player group")

func setup_animation_sprite():
	$AnimatedSprite2D.sprite_frames = item_data.frames
	$AnimatedSprite2D.animation = item_data.animation_name
	$AnimatedSprite2D.play()
	
func handle_audio():
	$AudioStreamPlayer2D.stream = item_data.pickup_sfx
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	return
