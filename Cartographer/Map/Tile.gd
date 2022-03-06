extends Node2D
	

var pos = Vector2.ZERO

signal on_mouse_entered(source)

func get_graphic():
	return $ClickableTile/Graphic

func _on_ClickableTile_mouse_entered():
	emit_signal("on_mouse_entered", self)

