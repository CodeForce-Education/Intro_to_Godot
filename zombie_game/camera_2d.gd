extends Camera2D

var screen_shake_start = false
var shake_intensity = 0

func _ready():
	Global.Camera = self
	
func _exit_tree():
	Global.Camera = null

func _process(delta):
	zoom = lerp(zoom, Vector2(1, 1), 0.3)
	
	if screen_shake_start == true:
		global_position += Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity)) * delta
		
func screen_shake(intesity, time):
	zoom = Vector2(1, 1) - Vector2(intesity * 0.002, intesity * 0.02)
	shake_intensity = intesity
	$screen_shake_timer.wait_time = time
	$screen_shake_timer.start()
	screen_shake_start = true
	
func _on_screen_shake_timer_timeout():
	screen_shake_start = false
	global_position = Vector2(576, 326)
