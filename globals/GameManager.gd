# GameData.gd (Global Autoload)
extends Node

# --- SAVED DATA VARIABLES ---
# Initialize as -1 to indicate "No saved data yet"
var savedHP: int = -1
var savedMaxHP: int = -1
var playerCoins: int = -1


# --- DATA MANIPULATION ---
func saveHealth(newHP: int, newMaxHP: int) -> void:
	savedHP = newHP
	savedMaxHP = newMaxHP 
	print("Health saved. HP: ", newHP, " - Max HP: ", newMaxHP)


# --- SCENE / GAME FLOW MANAGEMENT ---
func handlePlayerDeath() -> void:
	# 1. Reset variables so the player doesn't spawn dead on reload!
	savedHP = -1 
	# (Keep max_hp and total_coins if they carry over after death!)
	
	# 2. Wait a moment for the death animation to play out nicely
	await get_tree().create_timer(1.5).timeout
	
	# 3. Reload the level
	get_tree().reload_current_scene()
