extends Node2D

var player_name = ""
onready var player_name_output = get_node("PlayerName")
const MAP_SIZE = 5
var map_state = []
onready var map_state_output = get_node("MapState")
onready var grid_output = get_node("Grid")
var current_tile_form = []
var current_tile_kind = "WATER"
onready var current_tile_grid_output = get_node("CurrentTileExample")
onready var current_tile_output = get_node("CurrentTile")
const TILE_SIZE = 50
var mirrored = true
var rotated = 0
var current_hover_position_form = []

func _ready():
	reset_and_randomize(0)

func set_player_name(name):
	player_name = name
	update_ui()

func update_ui():
	player_name_output.set_text("player_name: " + player_name)
	map_state_output.set_text("map_state: " + String(map_state))
	current_tile_output.set_text("current_tile: " + String(current_tile_form) + " | " + current_tile_kind + " \nmirrored: " + String(mirrored) + " | rotated: " + String(rotated)+ " \ncurrent_hover: " + String(current_hover_position_form))
	
	draw_map()
	draw_current_tile(current_tile_form, current_tile_kind)

func reset_and_randomize(_local_seed):
	player_name = ""
	for _i in range(MAP_SIZE):
		var row = []
		for _j in range(MAP_SIZE):
			row.append("EMPTY")
		map_state.append(row)
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
			if elem == "EMPTY":
				for t in current_hover_position_form:
					if t.x == x and t.y == y:
						elem = current_tile_kind
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
	var trans_form = transform_form(form) 
	
	for e in trans_form:
		var inst = tile.instance()
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

func get_corr_vec(trans_form):
	var corr_vec = Vector2.ZERO
	for e in trans_form:
		if corr_vec.x > e.x:
			corr_vec.x = e.x
		if corr_vec.y > e.y:
			corr_vec.y =e.y
	return corr_vec

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("mirror_tile"):
		current_hover_position_form = []
		mirrored = !mirrored
		update_ui()
	if Input.is_action_pressed("rotate_tile"):
		current_hover_position_form = []
		if rotated == 3:
			rotated = 0
		else:
			rotated = rotated + 1
		update_ui()

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func set_current_tile(form, kind):
	mirrored = false
	rotated = 0
	current_hover_position_form = []
	current_tile_form = form
	current_tile_kind = kind
	update_ui()
	
func mirror_vec(v, max_width):
	var v2 = Vector2(v.x, v.y)
	if mirrored:
		v2.x = max_width - v.x
	return v2

func rotate_vec(v):
	if rotated == 0:
		return v
	if rotated == 1:
		return v.rotated(deg2rad(90)).round()
	if rotated == 2:
		return v.rotated(deg2rad(180)).round()
	if rotated == 3:
		return v.rotated(deg2rad(270)).round()

func move_vec(v, corr):
	v.x = v.x + corr.x
	v.y = v.y + corr.y
	return v

func transform_form(form):
	var newForm = []
	for e in form:
		var m = mirror_vec(e, get_max_width(form))
		var r = rotate_vec(m)
		newForm.append(r)
	var corr = get_corr_vec(newForm)
	var newNewForm = []
	for e in newForm:
		var a = move_vec(e, Vector2(-1 * corr.x, -1 * corr.y))
		newNewForm.append(a)
	return newNewForm

func on_Tile_mouse_entered(tile):
	current_hover_position_form = []
	for v in transform_form(current_tile_form):
		var new_v = move_vec(v, tile.pos)
		current_hover_position_form.append(new_v)
	for v in current_hover_position_form:
		if v.x >= MAP_SIZE:
			current_hover_position_form = []
		elif v.y >= MAP_SIZE:
			current_hover_position_form = []
		elif !(map_state[v.y][v.x] == "EMPTY"):
			current_hover_position_form = []
	update_ui()

func on_Tile_mouse_clicked(tile):
	print("click: " + String(tile.pos))
