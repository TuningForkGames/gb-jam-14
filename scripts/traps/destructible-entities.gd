extends Node2D

@export var bExplisionRequired : bool		= true
@export var bDesotryed : bool				= false
@export var linkedDestory : Node2D

@onready var health : Health 				= $Health

func _ready() -> void:
	print("Wall loaded")
	if bDesotryed:
		_destory()
	health.died.connect(_destory)
	health.health_changed.connect(_test)
	
func _destory() -> void:
	if linkedDestory:
		linkedDestory.queue_free()
	queue_free()

func _test(hp : int) -> void:
	print("It's takign damage new hp = ", hp)
