extends Area2D

@export var speed: float = 600

func _process(delta):
	position.y -= speed * delta
	

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		self.queue_free()
