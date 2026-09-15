extends Node
class_name Health

#Health Component
@export var invuln_time	: float = 0.8
var invuln_until_ms		: float = 0
@export var max_hp 		: int = 25
var hp 					: int
var is_dead				: bool = false

#signals
signal health_changed(current, max)
signal died

func _ready() -> void:
	if max_hp > 0:
		hp = max_hp
	else:
		push_error("Max HP isn't set.")
		
	if invuln_time < 0:
		push_error("invuln_time isn't set.")

#use this function to pass a whole positive int for damge e.g take_damage(5)
func take_damage(amount : int):
	if Time.get_ticks_msec() < invuln_until_ms or is_dead: return
	
	hp = clampi(hp - amount, 0, max_hp)
	health_changed.emit(hp, max_hp)
	if hp == 0:
		is_dead = true
		died.emit()
	else:
		invuln_until_ms = Time.get_ticks_msec() + invuln_time * 1000

#use this function to pass a whole positive int for healing e.g heal(5)
func heal(amount : int):
	if is_dead: return
	hp = clampi(hp + amount, 0, max_hp)
	health_changed.emit(hp, max_hp)
