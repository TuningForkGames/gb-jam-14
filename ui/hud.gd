extends CanvasLayer

@onready var coinLabel: Label = $CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideDialogeBox()
	if GameManager.playerCoins > 0:
		updateCoinCounter(GameManager.playerCoins)
		
	# 1. Connect the HUD directly to the global GameManager Coin Collected signal
	GameManager.coinCountUpdated.connect(updateCoinCounter)


func hideDialogeBox():
	$DialogueBox.visible = false

func updateHearts(currHP):
	$Heart01.visible = true
	$Heart02.visible = true
	$Heart03.visible = true
	$Heart04.visible = true
	$Heart05.visible = true
	if currHP == 0:
		$Heart01.visible = false
		$Heart02.visible = false
		$Heart03.visible = false
		$Heart04.visible = false
		$Heart05.visible = false
	elif currHP == 1:
		$Heart02.visible = false
		$Heart03.visible = false
		$Heart04.visible = false
		$Heart05.visible = false
	elif currHP == 2:
		$Heart03.visible = false
		$Heart04.visible = false
		$Heart05.visible = false
	elif currHP == 3:
		$Heart04.visible = false
		$Heart05.visible = false
	elif currHP == 4:
		$Heart05.visible = false
	else:
		print("No more hearts to show on HUD")

func updateCoinCounter(amount: int):
	 # Caps the number at 999 just in case it goes over
	var clampedAmount: int = clampi(amount, 0, 999)
	# Formats the number to always be 3 digits and set the UI element accordingly
	coinLabel.text = "%03d" % clampedAmount
