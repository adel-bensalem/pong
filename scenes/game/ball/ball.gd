extends CharacterBody2D

signal collide(collision: KinematicCollision2D)

func _process(delta):
	var collision = move_and_collide(velocity)
	
	if collision:
		collide.emit(collision)

func get_size():
	return $Sprite2D.get_rect().size
