extends CharacterBody2D

@export var flipped: bool = false:
	set(is_flipped):
		$AnimatedSprite2D.flip_h = is_flipped

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.animation_finished.connect(on_animation_finished)

func play_hit_animation():
	$AnimatedSprite2D.play("hit")

func get_size():
	var current_animation = $AnimatedSprite2D.animation
	
	return $AnimatedSprite2D.sprite_frames.get_frame_texture(current_animation, 0).get_size()

func on_animation_finished():
	if $AnimatedSprite2D.animation == "hit":
		$AnimatedSprite2D.play("idle")
