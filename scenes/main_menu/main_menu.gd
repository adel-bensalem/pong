extends CanvasLayer

signal start()

@onready var start_button = $BoxContainer/StartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start():
	start.emit()
