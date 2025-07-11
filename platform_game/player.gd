extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 30

@onready var sprite = $Sprite2D
@onready var hurtBox = $hurtBox
@onready var jumpBox = $jumpBox

@onready var anim = $AnimationPlayer
@onready var hurtAnim = $AnimationPlayerHurt
@onready var hurtTimer = $Timer
@onready var cam = $"../Camera2D"

@onready var heart1 = $"../Camera2D/fullHeart1"
@onready var heart2 = $"../Camera2D/fullHeart2"
@onready var heart3 = $"../Camera2D/fullHeart3"

@onready var gameOverLabel =  $"../Camera2D/GameOverLabel"
@onready var winLabel =  $"../Camera2D/WinLabel"
@onready var coinText =  $"../Camera2D/LabelCoin"

var randomStrength: float = 30.0
var shakeFade: float = 5.0

var coinCount: int = 0

var shake_strength: float = 0.0
var rng = RandomNumberGenerator.new()

var gameOver: bool = false
var timesJumped = 0
var hurting: bool = false
var playerHealth: int = 3
var timesShook: int = 0
var gameWin: bool = false

func _process(delta):
	#show coin text
	coinText.text = str(coinCount)
	#heart state code
	if playerHealth == 3:
		heart1.visible = true
		heart2.visible = true
		heart3.visible = true
	if playerHealth == 2:
		heart1.visible = false
		heart2.visible = true
		heart3.visible = true
	if playerHealth == 1:
		heart1.visible = false
		heart2.visible = false
		heart3.visible = true
	if playerHealth == 0 or timesShook == 1:
		heart1.visible = false
		heart2.visible = false
		heart3.visible = false
		
func apply_shake():
	shake_strength = randomStrength
	
func randomOffset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _physics_process(delta):
	#reset jumps
	if is_on_floor():
		timesJumped = 0
		
	#limit gravity
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	#player jump button
	if Input.is_action_just_pressed("jump") and timesJumped < 2 and gameOver == false and gameWin == false:
		velocity.y = -jump_force
		timesJumped += 1
	
	#player input direction
	var horizontal_movement = Input.get_axis("move_left", "move_right")
	
	#player anim state
	if gameOver == false and gameWin == false:
		if velocity.x == 0 or !is_on_floor():
			anim.play("RESET")
		else:
			anim.play("walk")
		if velocity.x > 0:
			sprite.flip_h = true
		elif velocity.x < 0:
			sprite.flip_h = false
		velocity.x = speed * horizontal_movement
		move_and_slide()
		
	#jump anim
	if velocity.y < 0:
		anim.play("jump")
		
	#player health state
	if playerHealth <= 0:
		gameOver = true
		gameOverLabel.visible = true
	
	#shake strength value
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		cam.offset = randomOffset()
		
	#restart game
	if Input.is_action_just_pressed("jump") and (gameOver == true or gameWin == true):
		get_tree().reload_current_scene()
	
	#game over state
	if gameOver == true:
		if timesShook == 0:
			apply_shake()
			timesShook = 1
		hurtAnim.play("hurting")
		gameOverLabel.visible = true
		anim.play("death")
		await anim.animation_finished
		position.y += 500
		
	#hurt anim state
	if hurting == false and gameOver == false or gameWin == true:
		hurtAnim.play("RESET")
	
	#jump box area
	for area in jumpBox.get_overlapping_areas():
		if area.name == "enemyHurtBox":
			velocity.y = -jump_force
			timesJumped = 1
		if area.name == "winArea":
			gameWin = true
			anim.play("RESET")
			winLabel.visible = true
	#hurt box area 
	for area in hurtBox.get_overlapping_areas():
		if area.name == "outOfBounds":
			gameOver = true
			if timesShook == 0:
				apply_shake()
				timesShook += 1
			hurtAnim.play("hurting")
			anim.play("death")
		if area.name == "enemy" and hurting == false:
			hurtByEnemy()
		if area.name == "coin":
			coinCount += 1

#hurt by enemy function
func hurtByEnemy():
	if gameOver == false:
		apply_shake()
	hurtAnim.play("hurting")
	hurting = true
	hurtTimer.start()
	playerHealth -= 1
	await hurtTimer.timeout
	hurting = false
