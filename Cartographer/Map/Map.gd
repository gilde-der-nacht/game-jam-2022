extends Node2D

var player_name = ""
onready var player_name_output = get_node("PlayerName")

func _ready():
	update_player_name()

func set_name(name):
	player_name = name
	update_player_name()

func update_player_name():
	player_name_output.set_text(player_name)

func reset_and_randomize(local_seed):
	player_name = ""
