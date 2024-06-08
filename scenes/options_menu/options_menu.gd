extends CanvasLayer

signal save
signal exit

@onready var volume_slider = $Menu/Options/Group/VolumeSlider
@onready var exit_button = $Menu/Buttons/ExitButton
@onready var save_button = $Menu/Buttons/SaveButton

@export var volume: int = 100:
	set(vol):
		volume = vol
		$Menu/Options/Group/VolumeSlider.value = vol

func _ready():
	exit_button.pressed.connect(on_exit)
	save_button.pressed.connect(on_save)
	volume_slider.value_changed.connect(on_volume_changed)

func on_exit():
	exit.emit()

func on_save():
	save.emit()
	
func on_volume_changed(value):
	volume = value
