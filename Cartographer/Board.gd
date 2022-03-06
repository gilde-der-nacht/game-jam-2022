extends Node2D

func _ready():
	pass

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
	pass

func _on_ButtonInstructionNextTurn_pressed():
	pass

func _on_ButtonMapReset_pressed():
	pass

func _on_ButtonMapSetPlayerNames_pressed():
	$Map1.set_name("Flutschi")
	$Map2.set_name("Oliver")
	$Map3.set_name("Thomas")


