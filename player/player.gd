extends CharacterBody2D

const SPEED = 100.0
@onready var _animated_sprite = $AnimatedSprite2D

func set_animation():
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
	var input_direction = Input.get_vector("left", "right", "up", "down")
	set_animation()
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
