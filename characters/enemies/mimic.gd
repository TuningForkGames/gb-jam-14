extends CharacterBody2D

@export var jump_distance: float = 16.0
@export var hop_speed: float = 0.8
@export var aggro_range: float = 32.0
@export var min_attack_range = 16.0
@export var coin_prefab: PackedScene

var _is_hopping = false
var _player: CharacterBody2D
var _hop_target: Vector2 = Vector2.ZERO

func _ready() -> void:
	#There's probably a better way to do this, but it works
	var root = get_tree().current_scene
	_player = root.find_child("Player", true, false) as CharacterBody2D	
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished);
	$HopCooldownTimer.start()
	
	if _player == null:
		print("wtf")
	
func _physics_process(delta: float) -> void:
	if _is_hopping:
		velocity += Vector2(get_gravity().length(), get_gravity().length()) * delta
		move_and_slide()
		
		var vec2Player: Vector2 = (_player.global_position - global_position)
		
		if vectors_nearly_equal(global_position, _hop_target, 8):
			_is_hopping = false
			velocity = Vector2.ZERO
			$Shadow.visible = false
			$HopCooldownTimer.start()
			
		if (vec2Player.length() <= min_attack_range):
			var face_dir: GB_GLOBALS.FaceDirection = get_player_face_direction()
			if  face_dir == GB_GLOBALS.FaceDirection.down:
				$AnimatedSprite2D.play("attack_down")
				$AnimatedSprite2D.flip_h = false
			elif face_dir == GB_GLOBALS.FaceDirection.up: 
				$AnimatedSprite2D.play("attack_up")
				$AnimatedSprite2D.flip_h = false
			elif face_dir == GB_GLOBALS.FaceDirection.right:
				$AnimatedSprite2D.play("attack_right")
				$AnimatedSprite2D.flip_h = false
			elif face_dir == GB_GLOBALS.FaceDirection.left:
				$AnimatedSprite2D.play("attack_right")
				$AnimatedSprite2D.flip_h = true

		
		if get_slide_collision_count() > 0:
			_is_hopping = false
			velocity = Vector2.ZERO
			$Shadow.visible = false
			$HopCooldownTimer.start()
	
func hop_to_player() -> void:
	if _player:
		var vec2Player: Vector2 = (_player.global_position - global_position)
	
		if (vec2Player.length() <= min_attack_range or vec2Player.length() >= aggro_range):
			_is_hopping = false
			velocity = Vector2.ZERO
			$Shadow.visible = false
			$HopCooldownTimer.start()
			return
		
		var max_jump_distance: float = jump_distance if vec2Player.length() > jump_distance else vec2Player.length()
		_hop_target =  (max_jump_distance * vec2Player.normalized())  + global_position
		velocity = calculate_arc_velocity(global_position, _hop_target, Vector2(get_gravity().length(), get_gravity().length()), hop_speed)
		_is_hopping = true
		#$Shadow.global_position = global_position + (_hop_target - global_position).normalized() * 4
		#$Shadow.visible = true
		
		var face_dir: GB_GLOBALS.FaceDirection = get_player_face_direction()
		if  face_dir == GB_GLOBALS.FaceDirection.down:
			$AnimatedSprite2D.play("move_down")
			$AnimatedSprite2D.flip_h = false
		elif face_dir == GB_GLOBALS.FaceDirection.up: 
			$AnimatedSprite2D.play("move_up")
			$AnimatedSprite2D.flip_h = false
		elif face_dir == GB_GLOBALS.FaceDirection.right:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = false
		elif face_dir == GB_GLOBALS.FaceDirection.left:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = true

func get_player_face_direction() -> GB_GLOBALS.FaceDirection:
	if _player:
		var vec2Player: Vector2 = (_player.global_position - global_position)
		if  abs(vec2Player.y) >= abs(vec2Player.x) && _player.global_position.y > global_position.y:
				return GB_GLOBALS.FaceDirection.down
		elif abs(vec2Player.y) >= abs(vec2Player.x) && _player.global_position.y < global_position.y: 
			return GB_GLOBALS.FaceDirection.up
		elif abs(vec2Player.x) > abs(vec2Player.y) && _player.global_position.x > global_position.x:
			return GB_GLOBALS.FaceDirection.right
		else:
			return GB_GLOBALS.FaceDirection.left
			
	return GB_GLOBALS.FaceDirection.down

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


func _on_health_component_died() -> void:
	if (coin_prefab != null): 
		var coin = coin_prefab.instantiate()
		get_tree().root.add_child(coin)
		coin.global_position = global_position
	queue_free()


func _on_health_component_health_changed(curr_hp: Variant) -> void:
	#modulate = Color("f9ffb365")
	$AnimatedSprite2D.visible = false
	get_tree().create_timer($HealthComponent.invuln_time).timeout.connect(_reset_color)

func _reset_color() -> void:
	$AnimatedSprite2D.visible = true
	#modulate = Color.WHITE
