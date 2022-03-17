extends Node2D
	

var pos = Vector2.ZERO

signal on_mouse_entered(source)
signal on_mouse_clicked(source)

func get_graphic():
	return $ClickableTile/Graphic

func _on_ClickableTile_mouse_entered():
	emit_signal("on_mouse_entered", self)

func _on_ClickableTile_input_event(_viewport, event, _shape_idx ):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("on_mouse_clicked", self)
