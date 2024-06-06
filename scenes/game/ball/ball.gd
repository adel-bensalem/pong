#extends CharacterBody2D
#
#signal collide(collider: Object)
#
#@export var speed = 350
#@export var direction_x = -1
#@export var direction_y = -1
#@export var bounceAngle = 0
#
#func _process(delta):
	#velocity.y = delta * speed * -sin(bounceAngle);
	#velocity.x = delta * speed * cos(bounceAngle);
	#
	#var collision = move_and_collide(velocity)
	#
	#if collision:
		#print(collision.get_angle())
		#collide.emit(collision.get_collider())
#
#func get_size():
	#return $ColorRect.size


extends CharacterBody2D

signal collide(collision: KinematicCollision2D)

func _process(delta):
	var collision = move_and_collide(velocity)
	
	if collision:
		collide.emit(collision)

func get_size():
	return $ColorRect.size
