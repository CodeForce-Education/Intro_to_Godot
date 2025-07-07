extends Area2D


@onready var box = $coin

func _physics_process(delta):
	for area in box.get_overlapping_areas():
		if area.name == "hurtBox":
			queue_free()
