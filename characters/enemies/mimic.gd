extends CharacterBody2D

@export var jump_distance: float = 16.0
@export var hop_speed: float = 4.0/5.0

var _is_hopping = false
var _player: CharacterBody2D
var _hop_target: Vector2 = Vector2.ZERO

func _ready() -> void:
	#There's probably a better way to do this, but it works
	var root = get_tree().current_scene
	_player = root.find_child("Player", true, false).find_child("CharacterBody2D", true, false)	
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished);
	#$Shadow.top_level = true
	hop_to_player()
	
func _physics_process(delta: float) -> void:
	if _is_hopping:
		velocity += Vector2(get_gravity().length(), get_gravity().length()) * delta
		move_and_slide()
		
		if vectors_nearly_equal(global_position, _hop_target, 8):
			_is_hopping = false
			velocity = Vector2.ZERO
			$Shadow.visible = false
			$HopCooldownTimer.start()
		
		if get_slide_collision_count() > 0:
			_is_hopping = false
			velocity = Vector2.ZERO
			$Shadow.visible = false
			$HopCooldownTimer.start()
	
func hop_to_player() -> void:
	if _player:
		var vec2Player: Vector2 = (_player.global_position - global_position)
		var max_jump_distance: float = jump_distance if vec2Player.length() > jump_distance else vec2Player.length()
		_hop_target =  (max_jump_distance * vec2Player.normalized())  + global_position
		velocity = calculate_arc_velocity(global_position, _hop_target, Vector2(get_gravity().length(), get_gravity().length()), hop_speed)
		_is_hopping = true
		#$Shadow.global_position = global_position + (_hop_target - global_position).normalized() * 4
		$Shadow.visible = true
		if _player.global_position.y > global_position.y:
			$AnimatedSprite2D.play("move_down")
		else: 
			$AnimatedSprite2D.play("move_up")

func calculate_arc_velocity(	start: Vector2, 
								target: Vector2, 
								decceleration: Vector2, 
								time: float
								) -> Vector2:
	return (target - start - 0.5 * decceleration * time * time) / time

func vectors_nearly_equal(a: Vector2, b: Vector2, tolerance: float = 0.01) -> bool:
	return a.distance_to(b) <= tolerance
	
func _on_animation_finished() -> void:
	#$AnimatedSprite2D.play("idle")
	pass


func _on_hop_cooldown_timer_timeout() -> void:
	hop_to_player()
