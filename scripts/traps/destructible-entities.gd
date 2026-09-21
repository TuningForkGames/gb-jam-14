extends Node2D

@export var bExplisionRequired : bool		= true
@export var bDesotryed : bool				= false
@export var linkedDestory : Node2D

func _ready() -> void:
	if bDesotryed:
		destory()

func destory():
	if linkedDestory:
		linkedDestory.queue_free()
	queue_free()
