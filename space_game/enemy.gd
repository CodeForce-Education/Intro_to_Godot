extends Area2D

@export var speed: float = 400
@onready var mainScene = $'../..'

func _process(delta):
	position.y += speed * delta
	


func _on_area_entered(area):
	self.queue_free()
	mainScene.score += 10
