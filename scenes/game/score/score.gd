extends Label

@export var score: int = 0

func _process(delta):
	text = str(score)
