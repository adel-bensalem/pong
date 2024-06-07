extends Node2D

@onready var player = $GameBoard/Player
@onready var opponent = $GameBoard/Opponent
@onready var ball = $GameBoard/Ball
@onready var player_score_board = $GameBoard/PlayerScore
@onready var opponent_score_board = $GameBoard/OpponentScore
@onready var ping_pong_sound = $PingPongSound

var speed = 450
@export var player_score = 0
@export var opponent_score = 0
var mouse_position_y = 0
var ball_direction_x = 1
var ball_direction_y = -1
var bounce_angle = 0
var last_hit_velocity = 0

func _ready():
	ball.collide.connect(on_ball_collision)

func _process(delta):
	update_scores()
	move_player()
	move_opponent(delta)
	move_ball(delta)


func on_ball_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	
	if collider == $GameBoard/Walls:
		if has_player_scored():
			player_score += 1
			reset_ball()
		elif has_opponent_scored():
			opponent_score += 1
			reset_ball()
		else:
			ball_direction_y = -ball_direction_y

	if collider == opponent or collider == player:
		var paddle = opponent if collider == opponent else player
		
		hit_paddle(paddle, collision)
	
func has_player_scored():
	var ball_x = ball.get_position()[0]
	var opponent_x = opponent.get_position()[0]
	
	return ball_x + ball.get_size()[0] > opponent_x + opponent.get_size()[0]
	
func has_opponent_scored():
	var ball_x = ball.get_position()[0]
	var player_x = player.get_position()[0]
	var ball_width = ball.get_size()[0]
	var player_width = player.get_size()[0]
	
	return ball_x - ball_width / 2 < player_x - player_width / 2

func reset_ball():
	var screen = get_viewport_rect().size
	
	ball.position = Vector2(screen[0] / 2, screen[1] / 2)
	last_hit_velocity = 0

func update_scores():
	player_score_board.score = player_score
	opponent_score_board.score = opponent_score

func move_player():
	var screen_height = get_viewport_rect().size[1]
	var player_height = player.get_size()[1]
	
	mouse_position_y = get_global_mouse_position()[1]
	
	if mouse_position_y < 0:
		mouse_position_y = 0
	elif mouse_position_y + player_height > screen_height:
		mouse_position_y = screen_height - player_height
	
	player.set_position(Vector2(player.position[0], mouse_position_y))

func move_opponent(delta):
	var screen_height = get_viewport_rect().size[1]
	var opponent_height = opponent.get_size()[1]
	var y_direction = sin(bounce_angle)
	var next_y = opponent.position[1] + delta * speed * y_direction * (-ball_direction_y)
	
	if next_y < 0:
		next_y = 0
	elif next_y + opponent_height > screen_height:
		next_y = screen_height - opponent_height
	
	opponent.set_position(Vector2(
		opponent.position[0],
		next_y
	))


func move_ball(delta):
	var max_force = last_hit_velocity if last_hit_velocity < 250 else 250
	var ball_speed = speed + speed / 100 * max_force
	
	ball.velocity = Vector2(
		delta * ball_speed * cos(bounce_angle) * ball_direction_x,
		delta * ball_speed * -sin(bounce_angle) * ball_direction_y
	)
	
func hit_paddle(paddle, collision):
	var paddle_height = paddle.get_size()[1]
	var relative_intersect_y = (paddle.position.y + (paddle_height / 2)) - collision.get_position().y;
	var normalized_relative_intersection_y = (relative_intersect_y / (paddle_height / 2));
	var max_angle = PI / 4
	
	last_hit_velocity = abs(collision.get_collider_velocity().y);
	bounce_angle = normalized_relative_intersection_y * max_angle;
	ball_direction_x = -ball_direction_x
	
	play_hit_sound()

func play_hit_sound():
	var initial_volume = ping_pong_sound.volume_db
	
	ping_pong_sound.volume_db = initial_volume + initial_volume * (last_hit_velocity / 2000)
	ping_pong_sound.play()
	ping_pong_sound.volume_db = initial_volume
