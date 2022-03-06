extends Node2D


const CardBase = preload("res://Instructions/Cards.tscn")
onready var CardDataBase = preload("res://Instructions/Scripts/Cards_Database.gd")

const Edict_CardList = ["SentinelWood", "Greenbough", "Treetower", "StonesideForest", "CanalLake", "MagesValley", 
	"TheGoldenGranary", "ShoresideExpanse", "Wildholds", "GreatCity", "GreengoldPlains", "Shieldgate", "Borderlands", "LostBarony", 
	"TheBrokenRoad", "TheCauldrons"]
var Explorer_CardList = ["GreatRiver", "Farmland", "Hamlet", "ForgottenForest", "HinterlandStream", "Homestead", "Orchard", "TreetopVillage", "Marshlands", "FishingVillage", "RiftLands"]
const Ruins_CardList = ['TempleRuins', 'OutpostRuins']
const Monster_CardList = ['GoblinAttack', 'BugbearAssault', 'KoboldOnslaugt', 'GnollRaid']
const Seasons_List = ['Spring', 'Summer', 'Fall', 'Winter']

var Decksize = 11
var Season_Timer = 0

var Seasons = "Spring"

var Explore_x = 460
var Explore_y = 600

#Edicts Arrays und Randomizer
var Edicts_Array = []
var rng = RandomNumberGenerator.new()

onready var game_state = "playing"

func _ready():
	game_state = "playing"
	var HatSchon = false
	while Edicts_Array.size() != 4:
		HatSchon = false
		var edict = rng.randi_range(1,15)
		for item in Edicts_Array:
			if item == edict:
				HatSchon = true
		if HatSchon == false:
			Edicts_Array.append(edict)

	generate_explorerdeck() 
	generate_edicts() 
	edict_select()

func reset(rng_seed):
	
	Edict_x = 460
	Edict_y = 300
	
	$"..".activate_round_button()
	Seasons = "Spring"
	
	rng.seed = rng_seed
	game_state = "playing"
	
	reset_deck()

	for N in $Card.get_children():
		$Card.remove_child(N)
		
	Edicts_Array = []
	all_Edicts = []
	
	var HatSchon = false
	while Edicts_Array.size() != 4:
		HatSchon = false
		var edict = rng.randi_range(1,15)
		for item in Edicts_Array:
			if item == edict:
				HatSchon = true
		if HatSchon == false:
			Edicts_Array.append(edict)

	generate_explorerdeck() 
	generate_edicts() 
	edict_select()
	
func next_turn():
	draw_card()

func is_last_turn():
	$"..".disable_round_button()
	Seasons = "Spring"
	infos_label.text += "\nGame Finished"
	game_state = "end"
	return "end"
		
func get_last_turn():
	return game_state
	
func get_season():
	return Seasons

func check_Season():
	match (Seasons):
		"Spring":
			if Season_Timer >= int(CardDataBase.DATA[CardDataBase.get("Spring")][2]):
				next_Season()
				edict_select()
				return
		"Summer":
			if Season_Timer >= int(CardDataBase.DATA[CardDataBase.get("Summer")][2]):
				next_Season()
				edict_select()
				return
		"Fall":
			if Season_Timer >= int(CardDataBase.DATA[CardDataBase.get("Fall")][2]):
				next_Season()
				edict_select()
				return
		"Winter":
			if Season_Timer >= int(CardDataBase.DATA[CardDataBase.get("Winter")][2]):
				next_Season()
				edict_select()
				return

func edict_select():
	var edict_counter = 1
	for edicts in all_Edicts:
		match(Seasons):
			"Spring":
				match(edict_counter):
					1:
						edicts.modulate = Color(1,1,1)
					2:
						edicts.modulate = Color(1,1,1)
					3:
						edicts.modulate = Color(0,1,0)
					4:
						edicts.modulate = Color(0,1,0)

			"Summer":
				match(edict_counter):
					1:
						edicts.modulate = Color(0,1,0)
					2:
						edicts.modulate = Color(1,1,1)
					3:
						edicts.modulate = Color(1,1,1)
					4:
						edicts.modulate = Color(0,1,0)
			"Fall":
				match(edict_counter):
					1:
						edicts.modulate = Color(0,1,0)
					2:
						edicts.modulate = Color(0,1,0)
					3:
						edicts.modulate = Color(1,1,1)
					4:
						edicts.modulate = Color(1,1,1)
			"Winter":
				match(edict_counter):
					1:
						edicts.modulate = Color(1,1,1)
					2:
						edicts.modulate = Color(0,1,0)
					3:
						edicts.modulate = Color(0,1,0)
					4:
						edicts.modulate = Color(1,1,1)
		
		
		edict_counter += 1	
	pass

func next_Season():
	print("Nexte Season" + str(Seasons))
	match(Seasons):
		"Spring":
			reset_deck()
			Seasons = "Summer"
			return
		"Summer":
			reset_deck()
			Seasons = "Fall"
			return
		"Fall":
			reset_deck()
			Seasons = "Winter"
			return
		"Winter":
			is_last_turn()
			return
	
func generate_explorerdeck():
	Explorer_CardList.shuffle()
	
func get_edicts():
	match(Seasons):
		"Spring":
			return [all_Edicts[0].Cardname, all_Edicts[1].Cardname]
		"Summer":
			return [all_Edicts[1].Cardname, all_Edicts[2].Cardname]
		"Fall":
			return [all_Edicts[2].Cardname, all_Edicts[3].Cardname]
		"Winter":
			return [all_Edicts[3].Cardname, all_Edicts[1].Cardname]

func get_explores():
	return active_explore.Cardname
	
	
func reset_deck():
		Season_Timer = 0
		Decksize = 11
		Explorer_CardList = ["GreatRiver", "Farmland", "Hamlet", "ForgottenForest", "HinterlandStream", "Homestead", "Orchard", "TreetopVillage", "Marshlands", "FishingVillage", "RiftLands"]
	
	
var active_explore = null
func draw_card():
	if game_state == "playing":	
		var new_explore = CardBase.instance()		
		var Explorer_CardName = Explorer_CardList[randi() % Decksize]
		new_explore.Cardname = Explorer_CardName
		new_explore.set_tile_pos(Vector2(Explore_x, Explore_y))
		new_explore.set_scale(Vector2(0.3, 0.3))
		Season_Timer += int(CardDataBase.DATA[CardDataBase.get(Explorer_CardName)][2])
		check_Season()
		infos_label.text = str(Seasons + "\n" + str(Season_Timer))
		$Card.add_child(new_explore)
		active_explore = new_explore
		Explorer_CardList.erase(Explorer_CardName)
		Decksize -= 1


var edict_scale = 0.2
var Edict_x_size = 180
var Edict_Size = 55
var Edict_x = 460
var Edict_y = 300

var infos_label = Label.new()		

var all_Edicts = []	

func generate_edicts():	
	for x in range(16):
		for item in Edicts_Array:
			if item == x:
				var new_edict = CardBase.instance()
				new_edict.Cardname = Edict_CardList[x]
				new_edict.set_tile_pos(Vector2(Edict_x, Edict_y))
				new_edict.set_scale(Vector2(edict_scale, edict_scale))
				$Card.add_child(new_edict)
				all_Edicts.append(new_edict)
				Edict_x += Edict_x_size
				

	infos_label.text = "Infos"
	infos_label.set_global_position(Vector2(300, 170))
	$Card.add_child(infos_label)
	
	var Label_x = 460
	
	for x in range(4):
		var new_label = Label.new()
		match (x):
			0:
				new_label.text = "A"
			1:
				new_label.text = "B"
			2:
				new_label.text = "C"
			3:
				new_label.text = "D"
				
		new_label.set_global_position(Vector2(Label_x, 170))
		$Card.add_child(new_label)
		Label_x += Edict_x_size
