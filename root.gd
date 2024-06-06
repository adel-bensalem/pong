extends Node2D

enum GameModes {
	MainMenu,
	Game,
	PauseMenu
}

var current_game_mode = GameModes.MainMenu

var main_menu = preload("res://scenes/main_menu/main_menu.tscn")
var game = preload("res://scenes/game/game.tscn")
var pause_menu = preload("res://scenes/pause_menu/pause_menu.tscn")
var current_game = null

func _ready():
	start_main_menu()

func _unhandled_key_input(event):
	if current_game_mode == GameModes.Game:
		if event.is_action_pressed("pause"):
			if !get_tree().paused:
				pause()
			else:
				un_pause()

func start_main_menu():
	for child in get_children():
		remove_child(child)
	
	current_game = main_menu.instantiate()
	current_game_mode = GameModes.MainMenu
	
	add_child(current_game)
	
	current_game.start.connect(start_game)

func start_game():
	for child in get_children():
		remove_child(child)
	
	current_game = game.instantiate()
	current_game_mode = GameModes.Game
	
	add_child(current_game)

func pause():
	add_child(pause_menu.instantiate())
	get_tree().paused = true

func un_pause():
	var pm = get_node("PauseMenu")
	
	if !!pm:
		remove_child(pm)
	
	get_tree().paused = false
