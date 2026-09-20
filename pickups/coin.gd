# Coin.gd
extends Pickup

@export var CoinValue: int = 1

#func apply_effect(player: Node2D) -> void:
	#GameManager.score += value

func apply_effect(player: Node2D) -> void:
	 # Check if the player has the collection function
	if player.has_method("collectCoin"):
		player.collectCoin(CoinValue)
