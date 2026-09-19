extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hideDialogeBox()


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
		
