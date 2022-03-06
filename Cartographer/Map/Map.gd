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
var current_tile_form = [Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(2,1)]
var current_tile_kind = "WATER"
onready var current_tile_grid_output = get_node("CurrentTileExample")
onready var current_tile_output = get_node("CurrentTile")
const TILE_SIZE = 50
var mirrored = true

func _ready():
	update_ui()

func set_player_name(name):
	player_name = name
	update_ui()

func update_ui():
	player_name_output.set_text("player_name: " + player_name)
	map_state_output.set_text("map_state: " + String(map_state))
	current_tile_output.set_text("current_tile: " + String(current_tile_form) + " | " + current_tile_kind + " | mirrored: " + String(mirrored))
	draw_map()
	draw_current_tile(current_tile_form, current_tile_kind)

func reset_and_randomize(_local_seed):
	player_name = ""
	map_state = map_empty_state.duplicate(true)
	update_ui()

func get_map():
	return map_state

func draw_map():
	delete_children(grid_output)
	var tile = preload("res://Map/Tile.tscn")
	var y_pos = 0
	var x_pos = 0
	for y in range(len(map_state)):
		for x in range(len(map_state[y])):
			var elem = map_state[y][x]
			var inst = tile.instance()
			inst.position.x = x_pos
			inst.position.y = y_pos
			inst.pos.x = x
			inst.pos.y = y
			inst.connect("on_mouse_entered", self, "on_Tile_mouse_entered")
			inst.connect("on_mouse_clicked", self, "on_Tile_mouse_clicked")
			draw_tile(inst, elem)
			grid_output.add_child(inst)
			x_pos += TILE_SIZE
		y_pos += TILE_SIZE
		x_pos = 0

func draw_tile(tile, state):
	var mountain_img = preload("res://Graphics/Mountain_Tile.png")
	var farm_img = preload("res://Graphics/Farm_Tile.png")
	var forest_img = preload("res://Graphics/Forest_Tile.png")
	var village_img = preload("res://Graphics/Village_Tile.png")
	var water_img = preload("res://Graphics/Water_Tile.png")
	var empty_img = preload("res://Graphics/Monster_Tile.png")
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
			sprite.texture = empty_img

func draw_current_tile(form: Array, type: String):
	delete_children(current_tile_grid_output)
	var tile = preload("res://Map/Tile.tscn")
	for e in form:
		var inst = tile.instance()
		if mirrored:
			var max_width = get_max_width(form)
			inst.position.x = (max_width - e.x) * TILE_SIZE
		else:
			inst.position.x = e.x * TILE_SIZE
		inst.position.y = e.y * TILE_SIZE
		draw_tile(inst, type)
		current_tile_grid_output.add_child(inst)

func get_max_width(form: Array):
	var max_width = 1
	for e in form:
		if e.x > max_width:
			max_width = e.x
	return max_width

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("mirror_tile"):
		mirrored = !mirrored
		update_ui()

func on_Tile_mouse_entered(tile):
	print("hover: " + String(tile.pos))

func on_Tile_mouse_clicked(tile):
	print("click: " + String(tile.pos))


func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
