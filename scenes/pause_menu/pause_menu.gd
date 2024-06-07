extends CanvasLayer

@onready var save_button = $Menu/Actions/SaveButton
@onready var exit_button = $Menu/Actions/ExitButton

func _ready():
	save_button.pressed.connect(save)
	exit_button.pressed.connect(exit)

func save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Score")
	var save_dict = {
		"player_score": 0,
		"opponent_score": 0,
	}
	
	for node in save_nodes:
		if node.name == "PlayerScore":
			save_dict["player_score"] = int(node.text)
		if node.name == "OpponentScore":
			save_dict["opponent_score"] = int(node.text)
	
	save_game.store_line(JSON.stringify(save_dict))

func exit():
	get_tree().quit() 
