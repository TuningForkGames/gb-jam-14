extends Node

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	player.healthComponent.health_changed.connect(hud.updateHearts)
	hud.updateHearts(player.healthComponent.curr_hp)
	# Bridge the gap between Player and HUD
	#print(player.heathComponent.currHP)
	
	# Set initial values
	# hud.set_max_health(player.health_component.max_health)
