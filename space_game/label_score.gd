extends Label

@onready var mainScene = $"../.."

func _process(delta):
	self.text = "Score: " + str(mainScene.score)
