extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# HEALING & DAMAGE
	if(Input.is_action_just_pressed("debug01")):
		GameManager.playerHP += 1
		print(GameManager.playerHP)
	if(Input.is_action_just_pressed("debug02")):
		GameManager.playerHP -= 1
		print(GameManager.playerHP)
