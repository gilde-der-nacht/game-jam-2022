extends Node2D

var player_name = ""
onready var player_name_output = get_node("PlayerName")
const map_empty_state = [
	["EMPTY","EMPTY","EMPTY"],
	["EMPTY","EMPTY","EMPTY"],
	["EMPTY","EMPTY","EMPTY"],
]
var map_state = map_empty_state.duplicate(true)
onready var map_state_output = get_node("MapState")

func _ready():
	update_ui()

func set_player_name(player_name):
	self.player_name = player_name
	update_ui()

func update_ui():
	player_name_output.set_text("player_name: " + player_name)
	map_state_output.set_text("map_state: " + String(map_state))

func reset_and_randomize(local_seed):
	player_name = ""
	map_state = map_empty_state.duplicate(true)
	update_ui()

func get_map():
	return map_state
