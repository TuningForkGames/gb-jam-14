## Plate controlled stream == mode CYCLING = active OFF. DO NOT PLACE MUZZLE INSIDE A WALL
extends Node2D
class_name SpikeTrap

enum FIREMODE{
	CYCLING,
	TRIGGERED
}

# timer for shot intervels
@onready var timer : Timer 				= $Timer
@onready var raisedTimer : Timer		= $RaisedTimer
@onready var hurtbox : CollisionShape2D	= $Area2D/CollisionShape2D
@onready var raisedSprite : Sprite2D	= $raised_sprite
@onready var loweredSprite : Sprite2D	= $lowred_sprite
@onready var area2D : Area2D			= $Area2D

@export var trigger_interval : float	= 2.0
@export var raised_time : float			= 0.5
# how much dmg the spikes does
@export var damage : int				= 1
@export var active : bool				= true
@export var mode  : FIREMODE			= FIREMODE.CYCLING
# where the arrow spawns

func _ready() -> void:
	if not hurtbox:
		push_error("You need to setup CollisionShape2D.")
		return
	if not area2D:
		push_error("You need to setup Area2D.")
		return
	if not timer:
		push_error("You need to setup timer.")
		return
	if not raisedTimer:
		push_error("You need to setup raisedTimer.")
		return
	area2D.body_entered.connect(_damage_player)
	timer.timeout.connect(_raise)
	timer.wait_time = trigger_interval
	raisedTimer.timeout.connect(_lower)
	raisedTimer.wait_time = raised_time
	raisedTimer.one_shot = true
	_lower()
	if mode == FIREMODE.CYCLING and active:
		timer.start()
		

func _cycle() -> void:
	if not active:
		timer.stop()
		return
	
	_raise()

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
				_raise()
		
func _raise() -> void:
	if not active: return
	hurtbox.set_deferred("disabled", false)
	raisedSprite.visible = true
	loweredSprite.visible = false
	raisedTimer.start()

func _lower() -> void:
	hurtbox.set_deferred("disabled", true)
	raisedSprite.visible = false
	loweredSprite.visible = true

func _damage_player(body : Node2D):
	print(body, " entered")
	if body.is_in_group("Player"):
		body.healthComponent.take_damage(damage)
	
func _flip_image():
	if loweredSprite.is_visible_in_tree():
		loweredSprite.visible = false
		raisedSprite.visible = true
	else:
		loweredSprite.visible = true
		raisedSprite.visible = false
