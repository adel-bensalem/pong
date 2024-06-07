extends CanvasLayer

signal start()

@onready var start_button = $Menu/Actions/StartButton

func _ready():
	start_button.pressed.connect(_on_start)

func _on_start():
	start.emit()
