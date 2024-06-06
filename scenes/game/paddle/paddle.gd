extends CharacterBody2D

@export var flipped: bool = false:
	set(is_flipped):
		$Sprite2D.flip_h = is_flipped

func get_size():
	return $Sprite2D.get_rect().size
