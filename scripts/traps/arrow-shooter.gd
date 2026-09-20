## Plate controlled stream == mode CYCLING = active OFF. DO NOT PLACE MUZZLE INSIDE A WALL
extends Node2D
class_name ArrowShooter

enum FIREMODE{
	CYCLING,
	TRIGGERED
}

# timer for shot intervels
@onready var timer : Timer = $Timer
@export var fire_interval : float	= 2.0
# how much dmg the projectile does
@export var damage : int			= 1
@export var active : bool			= true
@export var mode  : FIREMODE		= FIREMODE.CYCLING
@export var direction : GB_GLOBALS.FaceDirection
# where the arrow spawns
@export var muzzle : Marker2D
@export var projectile_to_spawn : PackedScene

func _ready() -> void:
	if not projectile_to_spawn:
		push_error("You need to set projectile_to_spawn.")
		return
	if not muzzle:
		push_error("You need to set muzzle so projectile knows where to spawn")
		return
	timer.timeout.connect(_cycle)
	timer.wait_time = fire_interval
	if mode == FIREMODE.CYCLING and active:
		timer.start()
		

func _cycle() -> void:
	if not active:
		timer.stop()
		return
	
	_fire()

func set_active(bOn : bool) -> void:
	if bOn:
		active = true
	if not bOn:
		active = false
		
	match mode:
		FIREMODE.CYCLING:
			if bOn:
				timer.start()
			else:
				timer.stop()
		FIREMODE.TRIGGERED:
			if bOn:
				_fire()
		
func _fire() -> void:
	#Play SFX if we want here
	var projectile = projectile_to_spawn.instantiate()
	projectile.position = to_local(muzzle.global_position)
	projectile.direction = direction
	projectile.damage = damage
	add_child.call_deferred(projectile)
