extends Node2D


const CardBase = preload("res://Instructions/Cards.tscn")

const Edict_CardList = ["SentinelWood", "Greenbough", "Treetower", "StonesideForest", "CanalLake", "MagesValley", 
	"theGoldenGranary", "ShoresideExpanse", "Wildholds", "GreatCity", "GreengoldPlains", "Shieldgate", "Borderlands", "LostBarony", 
	"theBrokenRoad", "TheCauldrons"]
const Explorer_CardList = ["GreatRiver", "Farmland", "Hamlet", "ForgottenForest", "HinterlandStream", "Homestead", "Orchard", "TreetopVillage", "Marshlands", "FishingVillage", "RiftLands"]
const Ruins_CardList = ['TempleRuins', 'OutpostRuins']
const Monster_CardList = ['GoblinAttack', 'BugbearAssault', 'KoboldOnslaugt', 'GnollRaid']

var Decksize = 11

var Edict_Size = 55
var Edict_x = 160
var Edict_y = 900
var Edict_x_size = 150

var Explore_x = 650
var Explore_y = 500

#Edicts Arrays und Randomizer
var Edicts_Array = []
var rng = RandomNumberGenerator.new()


func _ready():
	pass
#	rng.randomize()
#	var HatSchon = false
#	while Edicts_Array.size() != 4:
#		HatSchon = false
#		var edict = rng.randi_range(1,15)
#		for item in Edicts_Array:
#			if item == edict:
#				HatSchon = true
#		if HatSchon == false:
#			Edicts_Array.append(edict)
#
#	generate_explorerdeck() 
#	generate_edicts() 

func reset_cards():
	randomize()
	#create Deck new
	draw_card()
	
func next_turn():
	draw_card()

	
func generate_explorerdeck():
	Explorer_CardList.shuffle()
	pass
	#Karte noch nicht zeigen, zuerst random in ein Deck schieben..
	
func draw_card():
	randomize()
	var new_explore = CardBase.instance()
	var Explorer_CardName = Explorer_CardList[randi() % Decksize]
	new_explore.Cardname = Explorer_CardName
	new_explore.set_tile_pos(Vector2(Explore_x, Explore_y))
	new_explore.set_scale(Vector2(0.3, 0.3))
	$Card.add_child(new_explore)
	Explorer_CardList.erase(Explorer_CardName)
	Decksize -= 1
	return Decksize
	

func generate_edicts():
	for x in range(16):
		for item in Edicts_Array:
			if item == x:
				var new_edict = CardBase.instance()
				new_edict.Cardname = Edict_CardList[x]
				new_edict.set_tile_pos(Vector2(Edict_x, Edict_y))
				$Cards.add_child(new_edict)
				Edict_x += Edict_x_size

