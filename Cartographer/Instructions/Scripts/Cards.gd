extends Node2D


onready var CardDataBase = preload("res://Instructions/Scripts/Cards_Database.gd")
var Cardname = ""
onready var CardInfo = CardDataBase.DATA[CardDataBase.get(Cardname)]
onready var CardImg = str("res://Graphics/", CardInfo[0], "/", Cardname, ".jpg")

func _ready():
	$Card.texture = load(CardImg)
	
func set_tile_pos(new_position: Vector2) -> void:
	position = new_position

func set_scale(new_scale):
	$Card.scale = new_scale
