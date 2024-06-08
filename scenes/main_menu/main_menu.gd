extends CanvasLayer

signal start
signal open_options

@onready var start_button = $Menu/Actions/StartButton
@onready var options_button = $Menu/Actions/OptionsButton

func _ready():
	start_button.pressed.connect(on_start)
	options_button.pressed.connect(on_open_options)

func on_start():
	start.emit()

func on_open_options():
	open_options.emit()
