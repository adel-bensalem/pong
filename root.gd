extends Node2D

enum GameModes {
	MainMenu,
	Game,
	PauseMenu
}

var current_game_mode = GameModes.MainMenu
var loaded_save = {"opponent_score": 0, "player_score": 0}
var main_menu = preload("res://scenes/main_menu/main_menu.tscn")
var game = preload("res://scenes/game/game.tscn")
var pause_menu = preload("res://scenes/pause_menu/pause_menu.tscn")
var options_menu = preload("res://scenes/options_menu/options_menu.tscn")
var current_game = null

func _ready():
	load_game()
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
	current_game.open_options.connect(open_options)

func start_game():
	for child in get_children():
		remove_child(child)
	
	current_game = game.instantiate()
	current_game_mode = GameModes.Game
	
	if loaded_save.has("player_score"):
		current_game.player_score = loaded_save["player_score"]
		
	
	if loaded_save.has("opponent_score"):
		current_game.opponent_score = loaded_save["opponent_score"]
	
	if loaded_save.has("volume"):
		current_game.volume = loaded_save["volume"]
	
	add_child(current_game)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		loaded_save = json.get_data()

func pause():
	var pm = pause_menu.instantiate()
	
	add_child(pm)
	get_tree().paused = true
	
	pm.resume.connect(un_pause)
	pm.open_options.connect(open_options)

func un_pause():
	var pm = get_node("PauseMenu")
	
	if !!pm:
		remove_child(pm)
	
	get_tree().paused = false

func open_options():
	var options = options_menu.instantiate()
	
	if loaded_save.has("volume"):
		options.volume = loaded_save["volume"]
	
	options.save.connect(save_options)
	options.exit.connect(exit_options)
	
	add_child(options)

func save_options():
	var options = get_node("OptionsMenu")
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	if !!options:
		var save_dict = {}
		
		save_dict.merge(loaded_save)
		save_dict.merge({ "volume": options.volume }, true)
		save_game.store_line(JSON.stringify(save_dict))
		loaded_save = save_dict
		
		remove_child(options)
		
		if current_game_mode == GameModes.Game:
			current_game.volume = options.volume

func exit_options():
	var options = get_node("OptionsMenu")
	
	if !!options:
		remove_child(options)
