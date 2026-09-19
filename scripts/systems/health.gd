extends Node
class_name Health

#Health Component
@export var startingHP	: int = 1
@export var max_hp 		: int = 5
var curr_hp 			: int
@export var invuln_time	: float = 0.8
var invuln_until_ms		: float = 0
var bIsDead				: bool = false

#signals
signal health_changed(curr_hp)
signal died

func _ready() -> void:
	if max_hp > 0:
		curr_hp = startingHP
	else:
		push_error("Max HP isn't set.")
		
	if invuln_time < 0:
		push_error("invuln_time isn't set.")
	
#use this function to pass a whole positive int for damge e.g take_damage(5)
func take_damage(amount : int):
	if Time.get_ticks_msec() < invuln_until_ms or bIsDead: return
	
	curr_hp = clampi(curr_hp - amount, 0, max_hp)
	health_changed.emit(curr_hp)
	if curr_hp == 0:
		bIsDead = true
		died.emit()
	else:
		invuln_until_ms = Time.get_ticks_msec() + invuln_time * 1000

#use this function to pass a whole positive int for healing e.g heal(5)
func heal(amount : int):
	if bIsDead: return
	curr_hp = clampi(curr_hp + amount, 0, max_hp)
	health_changed.emit(curr_hp)
