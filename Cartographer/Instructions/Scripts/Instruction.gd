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
	print("Pressed")
	pass # Replace with function body.
