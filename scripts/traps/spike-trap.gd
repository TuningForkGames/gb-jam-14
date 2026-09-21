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

var bIsDeadly : bool					= false

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
	area2D.body_entered.connect(_on_body_entered)
	if mode == FIREMODE.TRIGGERED:
		area2D.body_exited.connect(_on_body_exited)
		
	timer.timeout.connect(_raise)
	timer.wait_time = trigger_interval
	raisedTimer.timeout.connect(_lower)
	raisedTimer.wait_time = raised_time
	raisedTimer.one_shot = true
	if mode == FIREMODE.CYCLING and active:
		timer.start()
		
		
func _raise() -> void:
	if not active: return
	bIsDeadly = true
	for b in area2D.get_overlapping_bodies():   # ← catches the stationary player
		_hurt(b)
	_flip_image()
	if mode != FIREMODE.TRIGGERED:
		raisedTimer.start()

func _lower() -> void:
	bIsDeadly = false
	_flip_image()

func _on_body_entered(body : Node2D):
	if mode == FIREMODE.TRIGGERED:
		_raise()
	elif bIsDeadly:
		_hurt(body)
		
func _on_body_exited(body : Node2D):
	if mode == FIREMODE.TRIGGERED:
		_lower()
		
func _hurt(body : Node2D):
	var found := body.find_children("*", "Health", true, false)
	if not found.is_empty():
		found[0].take_damage(damage)
		
func _flip_image():
	if loweredSprite.is_visible_in_tree():
		loweredSprite.visible = false
		raisedSprite.visible = true
	else:
		loweredSprite.visible = true
		raisedSprite.visible = false
