extends Node2D

enum GameModes {
	MainMenu,
	Game
}

var current_game_mode = GameModes.MainMenu

var main_menu = preload("res://scenes/main_menu/main_menu.tscn")
var game = preload("res://scenes/game/game.tscn")

func _ready():
	start_main_menu()

func start_main_menu():
	for child in get_children():
		remove_child(child)
	
	var current_game = main_menu.instantiate()
	
	add_child(current_game)
	
	current_game_mode = GameModes.MainMenu
	current_game.start.connect(start_game)

func start_game():
	for child in get_children():
		remove_child(child)
	
	add_child(game.instantiate())
	current_game_mode = GameModes.Game
