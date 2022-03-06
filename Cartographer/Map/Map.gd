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
onready var grid_output = get_node("Grid")

func _ready():
	update_ui()

func set_player_name(player_name):
	self.player_name = player_name
	update_ui()

func update_ui():
	player_name_output.set_text("player_name: " + player_name)
	map_state_output.set_text("map_state: " + String(map_state))
	draw_map()

func reset_and_randomize(local_seed):
	player_name = ""
	map_state = map_empty_state.duplicate(true)
	update_ui()

func get_map():
	return map_state

func draw_map():
	var tile = preload("res://Map/Tile.tscn")
	var y_pos = 0
	var x_pos = 0
	for y in map_state:
		for x in y:
			var inst = tile.instance()
			inst.position.x = x_pos
			inst.position.y = y_pos
			draw_tile(inst, x)
			grid_output.add_child(inst)
			x_pos += 50
		y_pos += 50
		x_pos = 0

func draw_tile(tile, state):
	var mountain_img = preload("res://Graphics/Mountain_Tile.png")
	var farm_img = preload("res://Graphics/Farm_Tile.png")
	var forest_img = preload("res://Graphics/Forest_Tile.png")
	var village_img = preload("res://Graphics/Village_Tile.png")
	var water_img = preload("res://Graphics/Water_Tile.png")
	var sprite = tile.get_graphic()
	match state:
		"MOUNTAIN":
			sprite.texture = mountain_img
		"FARM":
			sprite.texture = farm_img
		"FOREST":
			sprite.texture = forest_img
		"VILLAGE":
			sprite.texture = village_img
		"WATER":
			sprite.texture = water_img
		_:
			sprite.texture = null
	
