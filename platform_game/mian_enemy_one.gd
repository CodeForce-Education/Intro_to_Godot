extends CharacterBody2D

@export var gravity = 30
@onready var hurtBox = $enemyHurtBox
@onready var anim = $AnimationPlayer

@onready var collisionBox1 = $CollisionShape2D
@onready var collisionBox2 = $enemy/CollisionShape2D
@onready var collisionBox3 = $enemyHurtBox/CollisionShape2D

@onready var sprite = $Sprite2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint = Marker2D

var startPosition
var endPosition
var isDead: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed

func _physics_process(delta):
	#play death anim
	if isDead == true:
		anim.play("dead")
	else:
		anim.play("RESET")
	
	#gravity limit
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	#flipping enemy
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	#update movement
	updateVelocity()
	move_and_slide()
	
	#hit box
	for area in hurtBox.get_overlapping_areas():
		if area.name == "jumpBox":
			hurting()

func hurting():
	collisionBox1.disabled = true
	collisionBox2.disabled = true
	collisionBox3.disabled = true
	isDead = true
	anim.play("dead")
	await anim.animation_finished
	queue_free()
	
