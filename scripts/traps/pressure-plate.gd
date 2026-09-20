extends Area2D
class_name PressurePlate

enum Mode
{
	MOMENTARY,
	LATCH_ONCE
}

@export var mode : Mode
# Target that get's activated/deactivated
@export var targets : Array[Node]

# var for Latch_Once so entered doesn't fire over and over
var _latched : bool 		= false
# this var is for plates that need continus pressure to stay active
var _count : int			= 0


func _ready() -> void:
	body_entered.connect(_notify_target.bind(true))
	if mode != Mode.LATCH_ONCE:
		body_exited.connect(_notify_target.bind(false))

func _notify_target(body : Node2D, bOn : bool) -> void:
	if _latched: return		
		
	if bOn: 
		_count+=1
		if _count != 1: return
	else:	
		_count-=1
		if _count != 0: return
	
	if mode == Mode.LATCH_ONCE:
		_latched = true
		
	_broadcast(bOn)

func _broadcast(bOn : bool):
	for target in targets:
		if not target: 
			push_error("target in targets was null, check the inspector to verify correct node.")
			continue
		
		if not target.has_method("set_active"):			
			push_error(target, " does not have a \"set_active\" function")
			continue
		
		target.set_active(bOn)
