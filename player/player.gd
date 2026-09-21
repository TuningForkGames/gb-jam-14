extends CharacterBody2D
class_name Player

# Set Initial Player Specific Defaults
@export var MaxSpeed: float = 100.0
@export var canMoveDiagonally: bool = true
@export var acceleration: float = 30
@export var maxCoins: int = 2
#@export var pushStrength: float = 500

signal playerHasDied
signal coin_collected(amount: int)

@onready var animatedSprite = $AnimationPlayer
@onready var healthComponent : Health = $HealthComponent
@onready var interactComponent = $InteractComponent

var FaceDirection: GB_GLOBALS.FaceDirection = GB_GLOBALS.FaceDirection.down

var can_move : bool = true:
	set(new_move):
		if not new_move:
			velocity = Vector2.ZERO
			
		can_move = new_move

func _ready() -> void:
	add_to_group("Player")
	animatedSprite.animation_finished.connect(handleAnimationFinished)
	
	# Check if the global vault actually has active mid-game data
	if GameManager.savedHP != -1:
		# Override the local health defaults with the saved game data
		healthComponent.max_hp = GameManager.savedMaxHP
		healthComponent.hp = GameManager.savedHP
	else:
		# No saved data exists! (e.g., New Game / Just testing the scene)
		# Push the component's default values up to the global tracker
		GameManager.saveHealth(healthComponent.curr_hp, healthComponent.max_hp)
		
	healthComponent.health_changed.connect(healthChanged)
	healthComponent.died.connect(onDeath)
	healthComponent.died.connect(GameManager.handlePlayerDeath)
	coin_collected.connect(GameManager.onPlayerCoinCollected)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug03"):
		attack()
	
func _physics_process(delta: float) -> void:
	if healthComponent.bIsDead:
		return
	
	if can_move: 
		movePlayer()
	
	move_and_slide()


func movePlayer(): 
	# Get you input vector
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Set player velocity with acceleration rate
	velocity = velocity.move_toward(input_direction * MaxSpeed, acceleration)
	
	# Play proper walking animation
	if input_direction.x < -0.01:
		animatedSprite.play("walk_left")
		FaceDirection = GB_GLOBALS.FaceDirection.left
	elif input_direction.x > 0.01:
		animatedSprite.play("walk_right")
		FaceDirection = GB_GLOBALS.FaceDirection.right
	elif input_direction.y < -0.01:
		animatedSprite.play("walk_up")
		FaceDirection = GB_GLOBALS.FaceDirection.up
	elif input_direction.y > 0.01:
		animatedSprite.play("walk_down")
		FaceDirection = GB_GLOBALS.FaceDirection.down
	else:
		if FaceDirection == GB_GLOBALS.FaceDirection.right: 
			animatedSprite.play("idle_right")
		elif FaceDirection == GB_GLOBALS.FaceDirection.left:
			animatedSprite.play("idle_left")
		elif FaceDirection == GB_GLOBALS.FaceDirection.down:
			animatedSprite.play("idle_down")
		elif FaceDirection == GB_GLOBALS.FaceDirection.up:
			animatedSprite.play("idle_up")
	
	#print(getPlayerFaceVector())
	# Update the inteaction area's position
	if input_direction != Vector2.ZERO:
		interactComponent.updateInteractDirection(input_direction)

func attack():
	can_move = false
	if FaceDirection == GB_GLOBALS.FaceDirection.right: 
		animatedSprite.play("sword_attack_right")
	elif FaceDirection == GB_GLOBALS.FaceDirection.left:
		animatedSprite.play("sword_attack_left")
	elif FaceDirection == GB_GLOBALS.FaceDirection.down:
		animatedSprite.play("sword_attack_down")
	elif FaceDirection == GB_GLOBALS.FaceDirection.up:
		animatedSprite.play("sword_attack_up")

func healthChanged(current):
	# Player animation and audio plays: heal
	pass

func maxHealthChanged(current):
	# Player animation and audio plays: max health increased
	pass

func collectCoin(amount: int) -> void:
	coin_collected.emit(amount)

func onDeath():
	# Player animation and audio plays: death
	# Alert GameManager of Player Death
	playerHasDied.emit()
	print("Player is DEAD")
	PlayerInventoryGlobal.Slot_A = null
	PlayerInventoryGlobal.Slot_B = null


func onRespawn():
	print("PLAYER HP RESET")
	get_tree().call_deferred("reload_current_scene")

func onEnemyEntered(body):
	print("An enemy entered your hitbox")
	healthComponent.take_damage(1)
	
func getPlayerFaceVector() -> Vector2:
	if FaceDirection == GB_GLOBALS.FaceDirection.left:
		return Vector2(-1.0, 0.0)
	elif FaceDirection == GB_GLOBALS.FaceDirection.right:
		return Vector2(1.0, 0.0)
	elif FaceDirection == GB_GLOBALS.FaceDirection.down:
		return Vector2(0.0, 1.0)
	elif FaceDirection == GB_GLOBALS.FaceDirection.up:
		return Vector2(0.0, -1.0)
			
	return Vector2(0.0, 0.0)
	
func handleAnimationFinished(anim_name: String) -> void:
	can_move = true


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	var healthcomp = body.get_node("HealthComponent") as Health
	if healthcomp != null:
		healthcomp.take_damage(1)
