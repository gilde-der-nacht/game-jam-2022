extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func flu_debug():
	pass
	
func next_turn():
	$Deck.next_turn()

func _on_Button_pressed():
	$Deck.draw_card()	

func _on_Button2_pressed():
	$Deck.reset()

func disable_round_button():
	$NextRoundButton.disabled = true

func activate_round_button():
	$NextRoundButton.disabled = false
	
func get_explore():
	return $Deck.get_explores()
	
func get_edicts():
	return $Deck.get_edicts()
	
func get_season():
	return $Deck.get_season()
