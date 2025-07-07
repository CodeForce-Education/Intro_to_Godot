extends Label


func _process(delta):
	text = str(Global.points)
	$"../Highscore".text = str(Global.highscore)
	
func _ready():
	if Global.points > Global.highscore:
		Global.highscore = Global.points
