extends Node2D

var maps = []
var map_functions = null;

func _ready():
	randomize();
	maps = [$Map1, $Map2, $Map3]
	map_functions = preload("res://MapFunctions.gd")
	map_functions.test()

func _process(delta):
	var move_adjust = delta * 500.0
	var camera = $Camera2D
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= move_adjust
	if Input.is_action_pressed("ui_right"):
		camera.position.x += move_adjust
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= move_adjust
	if Input.is_action_pressed("ui_down"):
		camera.position.y += move_adjust
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()

func _on_ButtonInstructionReset_pressed():
	var local_seed = 8 # randi()
	$Instruction.game_reset(local_seed)

func _on_ButtonInstructionNextTurn_pressed():
	if $Instruction.get_last_turn() == "end":
		$Log.text += "END!"
	else:
		$Instruction.next_turn()
		var season = $Instruction.get_season()
		var edicts = $Instruction.get_edicts()
		var explore = $Instruction.get_explore()
		var last_turn = $Instruction.get_last_turn()
		$Log.text += "Season: " + String(season) + "\n"
		$Log.text += "Edicts: " + String(edicts) + "\n"
		$Log.text += "Explore: " + String(explore) + "\n"
		$Log.text += "LastTurn: " + String(last_turn) + "\n"
	$Log.cursor_set_line($Log.get_line_count()) # scroll to bottom

func _on_ButtonMapReset_pressed():
	var local_seed = 8 # randi()
	for map in maps:
		map.reset_and_randomize(local_seed)

func _on_ButtonMapSetPlayerNames_pressed():
	$Map1.set_player_name("Flutschi")
	$Map2.set_player_name("Oliver")
	$Map3.set_player_name("Thomas")
