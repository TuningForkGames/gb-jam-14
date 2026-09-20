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

@onready var animatedSprite = $AnimatedSprite2D
@onready var healthComponent : Health = $HealthComponent
@onready var interactComponent = $InteractComponent

var can_move : bool = true:
	set(new_move):
		if not new_move:
			velocity = Vector2.ZERO
			if animatedSprite:
				animatedSprite.stop()
			
		can_move = new_move

func _ready() -> void:
	add_to_group("Player")
	
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
	if Input.is_action_pressed("left"):
		animatedSprite.play("walk_left")
	elif Input.is_action_pressed("right"):
		animatedSprite.play("walk_right")
	elif Input.is_action_pressed("up"):
		animatedSprite.play("walk_up")
	elif Input.is_action_pressed("down"):
		animatedSprite.play("walk_down")
	else:
		animatedSprite.stop()
	
	# Update the inteaction area's position
	if input_direction != Vector2.ZERO:
		interactComponent.updateInteractDirection(input_direction)
	

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


func onRespawn():
	print("PLAYER HP RESET")
	get_tree().call_deferred("reload_current_scene")

func onEnemyEntered(body):
	print("An enemy entered your hitbox")
	healthComponent.take_damage(1)
