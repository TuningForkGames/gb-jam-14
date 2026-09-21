# Coin.gd
extends Pickup

@export var CoinValue: int = 1

#func apply_effect(player: Node2D) -> void:
	#GameManager.score += value

func apply_effect(player: Node2D) -> void:
	# Check tjat the player has the collection function and hasn't reached max coins.
	if player.has_method("collectCoin") and GameManager.playerCoins < player.maxCoins:
		visible = false
		player.collectCoin(CoinValue)
		$CollisionShape2D.disabled = true
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.finished.connect(play_gather_animation)
		#play_gather_animation()
	else:
		print("Your purse is full. It's a very manly purse.")
