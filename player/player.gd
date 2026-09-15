extends CharacterBody2D

const SPEED = 100.0
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _health_system : Health = $"Health-System"
@export var can_move : bool = true:
	set(new_move):
		if not new_move:
			velocity = Vector2.ZERO
			if _animated_sprite:
				_animated_sprite.stop()
			
		can_move = new_move

func _ready() -> void:
	_health_system.health_changed.connect( _health_changed)
	_health_system.died.connect(_died)

func set_animation():
	if(_health_system.is_dead): return
	
	var animation_to_run
	if Input.is_action_pressed("left"):
		animation_to_run = "walk_left"
	elif Input.is_action_pressed("right"):
		animation_to_run = "walk_right"
	elif Input.is_action_pressed("up"):
		animation_to_run = "walk_up"
	elif Input.is_action_pressed("down"):
		animation_to_run = "walk_down"
		
	if animation_to_run != null:
		_animated_sprite.play(animation_to_run)
	else:
		_animated_sprite.stop()
	

func get_input():
	if not can_move: return
	var input_direction = Input.get_vector("left", "right", "up", "down")
	################### DELETE LATER #######################################
	if(Input.is_key_pressed(KEY_R)):
		_health_system.take_damage(5)
	if(Input.is_key_pressed(KEY_H)):
		_health_system.heal(5)
	#########################################################################
	set_animation()
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func _health_changed(current, max_hp):
	print("Current hp = ", current, "Max is = ", max_hp)

func _died():
	can_move = false
	print("Player died")
