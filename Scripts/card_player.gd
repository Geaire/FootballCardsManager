extends Node2D

# --- NOEUDS ---
@onready var card_background = $CardBackground
@onready var txt_note = $TXT_Note
@onready var txt_position1 = $TXT_Position1
@onready var txt_position2 = $TXT_Position2
@onready var img_specialty1 = $IMG_Specialty1
@onready var img_specialty2 = $IMG_Specialty2
@onready var img_flag = $IMG_Flag
@onready var txt_firstname = $TXT_FirstName
@onready var txt_lastname = $TXT_LastName
@onready var btn_pincolor = $BTN_PinColor

# --- DONNEES ---
var note: int
var color: String = ""
var position1: String = ""
var position2: String = ""
var position2_unlocked: int = 0
var age: int
var height: int
var weight: int
var nationality: String = ""
var specialty1: String = ""
var specialty2: String = ""
var firstname: String = ""
var lastname: String = ""
var pin_color: String = ""
var clickable: bool = true
var deco_index: int = 0
var strength: int
var speed: int
var aggression: int
var positioning: int
var stamina: int
var creativity: int
var concentration: int
var motivation: int
var anticipation: int
var communication: int

# --- CONSTANTES ---
const POSITIONS = ["GB","DG","DD","DC","MG","MD","MDF","MC","MO","AG","AD","AC","ATT"]

const CARD_COLORS = {
	"yellow": Color(1.0, 0.85, 0.0),
	"orange": Color(1.0, 0.5, 0.0),
	"red": Color(0.9, 0.1, 0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"blue": Color(0.2, 0.5, 1.0),
	"white": Color(1.0, 1.0, 1.0)
}

const SPECIALTIES_GB = ["command", "reflexes"]
const SPECIALTIES_FIELD = ["crossing", "dribbling", "heading", "passing", "shooting", "tackling"]

const TOP_COUNTRIES = ["br","de","ar","fr","it","es","gb","pt"]
const STRONG_COUNTRIES = [
	"nl","be","hr","pl","se","ma","sn","gh","ng","us","mx","jp","kr","au",
	"ru","cz","tr","ro","dk","no"
]
const OTHER_COUNTRIES = [
	"ca","ch","at","bg","gr","ua","rs","si","ie","za",
	"eg","dz","tn","cm","ci","iq","sa","qa","kw",
	"cl","pe","co","ec","py","bo","uy","cr","hn","pa",
	"cn","ir","ae","ao","ba","cd","cu","ht","id","il",
	"jm","kp","ni","nz","sc","sv","tg","tt","wa"
]

const COUNTRY_TO_NAME_FILE = {
	"fr": "res://Data/Names/names_french.json",
	"be": "res://Data/Names/names_french.json",
	"ch": "res://Data/Names/names_french.json",
	"ht": "res://Data/Names/names_french.json",
	"cd": "res://Data/Names/names_french.json",
	"ci": "res://Data/Names/names_french.json",
	"cm": "res://Data/Names/names_french.json",
	"br": "res://Data/Names/names_portuguese.json",
	"pt": "res://Data/Names/names_portuguese.json",
	"ao": "res://Data/Names/names_portuguese.json",
	"es": "res://Data/Names/names_spanish.json",
	"ar": "res://Data/Names/names_spanish.json",
	"mx": "res://Data/Names/names_spanish.json",
	"cl": "res://Data/Names/names_spanish.json",
	"co": "res://Data/Names/names_spanish.json",
	"pe": "res://Data/Names/names_spanish.json",
	"ec": "res://Data/Names/names_spanish.json",
	"py": "res://Data/Names/names_spanish.json",
	"bo": "res://Data/Names/names_spanish.json",
	"uy": "res://Data/Names/names_spanish.json",
	"cr": "res://Data/Names/names_spanish.json",
	"hn": "res://Data/Names/names_spanish.json",
	"pa": "res://Data/Names/names_spanish.json",
	"cu": "res://Data/Names/names_spanish.json",
	"sv": "res://Data/Names/names_spanish.json",
	"ni": "res://Data/Names/names_spanish.json",
	"it": "res://Data/Names/names_italian.json",
	"de": "res://Data/Names/names_german.json",
	"at": "res://Data/Names/names_german.json",
	"nl": "res://Data/Names/names_german.json",
	"gb": "res://Data/Names/names_english.json",
	"us": "res://Data/Names/names_english.json",
	"au": "res://Data/Names/names_english.json",
	"ie": "res://Data/Names/names_english.json",
	"ca": "res://Data/Names/names_english.json",
	"nz": "res://Data/Names/names_english.json",
	"jm": "res://Data/Names/names_english.json",
	"tt": "res://Data/Names/names_english.json",
	"wa": "res://Data/Names/names_english.json",
	"sc": "res://Data/Names/names_english.json",
	"za": "res://Data/Names/names_english.json",
	"ng": "res://Data/Names/names_english.json",
	"gh": "res://Data/Names/names_english.json",
	"id": "res://Data/Names/names_english.json",
	"il": "res://Data/Names/names_english.json",
	"tr": "res://Data/Names/names_english.json",
	"hr": "res://Data/Names/names_slavic.json",
	"pl": "res://Data/Names/names_slavic.json",
	"ru": "res://Data/Names/names_slavic.json",
	"ua": "res://Data/Names/names_slavic.json",
	"rs": "res://Data/Names/names_slavic.json",
	"si": "res://Data/Names/names_slavic.json",
	"cz": "res://Data/Names/names_slavic.json",
	"bg": "res://Data/Names/names_slavic.json",
	"ro": "res://Data/Names/names_slavic.json",
	"ba": "res://Data/Names/names_slavic.json",
	"se": "res://Data/Names/names_scandinavian.json",
	"dk": "res://Data/Names/names_scandinavian.json",
	"no": "res://Data/Names/names_scandinavian.json",
	"ma": "res://Data/Names/names_arabic.json",
	"dz": "res://Data/Names/names_arabic.json",
	"tn": "res://Data/Names/names_arabic.json",
	"eg": "res://Data/Names/names_arabic.json",
	"sa": "res://Data/Names/names_arabic.json",
	"qa": "res://Data/Names/names_arabic.json",
	"kw": "res://Data/Names/names_arabic.json",
	"iq": "res://Data/Names/names_arabic.json",
	"ae": "res://Data/Names/names_arabic.json",
	"ir": "res://Data/Names/names_persian.json",
	"sn": "res://Data/Names/names_african.json",
	"tg": "res://Data/Names/names_african.json",
	"jp": "res://Data/Names/names_asian.json",
	"kr": "res://Data/Names/names_asian.json",
	"cn": "res://Data/Names/names_asian.json",
	"kp": "res://Data/Names/names_asian.json",
	"gr": "res://Data/Names/names_greek.json",
	"default": "res://Data/Names/names_english.json"
}

# --- READY ---
func _ready():
	if get_parent() == get_tree().root:
		position = get_viewport_rect().size / 2
		generate()
		display()

# --- GENERATION ---
func generate():
	generate_note_and_color()
	generate_age_height_weight()
	generate_nationality()
	generate_positions()
	generate_name()
	generate_specialties()
	generate_skills()

func generate_note_and_color():
	var roll = randi_range(1, 1000)
	if roll <= 400:
		note = randi_range(60, 69)
		color = "yellow"
	elif roll <= 650:
		note = randi_range(70, 79)
		color = "orange"
	elif roll <= 850:
		note = randi_range(80, 89)
		color = "red"
	elif roll <= 970:
		note = randi_range(90, 99)
		color = "magenta"
	else:
		note = randi_range(100, 129)
		color = "blue"

func generate_age_height_weight():
	var roll = randi_range(1, 100)
	if roll <= 1:
		age = randi_range(18, 19)
	elif roll <= 5:
		age = randi_range(20, 21)
	elif roll <= 15:
		age = randi_range(22, 23)
	elif roll <= 80:
		age = randi_range(24, 28)
	else:
		age = randi_range(29, 32)
	height = randi_range(168, 198)
	var imc = randi_range(195, 245) / 10.0
	weight = int(round(imc * (height / 100.0) * (height / 100.0)))

func generate_nationality():
	var roll = randi_range(1, 100)
	if roll <= 60:
		nationality = TOP_COUNTRIES[randi_range(0, TOP_COUNTRIES.size() - 1)]
	elif roll <= 80:
		nationality = STRONG_COUNTRIES[randi_range(0, STRONG_COUNTRIES.size() - 1)]
	else:
		nationality = OTHER_COUNTRIES[randi_range(0, OTHER_COUNTRIES.size() - 1)]

func generate_positions():
	position1 = POSITIONS[randi_range(0, POSITIONS.size() - 1)]
	if position1 == "GB":
		position2 = ""
		return
	var roll = randi_range(1, 100)
	if roll <= 10:
		var candidates = []
		for p in POSITIONS:
			if p != position1 and p != "GB":
				candidates.append(p)
		position2 = candidates[randi_range(0, candidates.size() - 1)]
	else:
		position2 = ""

func generate_name():
	var path = COUNTRY_TO_NAME_FILE.get(nationality, COUNTRY_TO_NAME_FILE["default"])
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		firstname = "John"
		lastname = "Doe"
		return
	var text = file.get_as_text()
	file.close()
	var json = JSON.parse_string(text)
	if typeof(json) != TYPE_DICTIONARY:
		firstname = "John"
		lastname = "Doe"
		return
	var firstnames = json["firstNames"]
	var lastnames = json["lastNames"]
	firstname = firstnames[randi_range(0, firstnames.size() - 1)]
	lastname = lastnames[randi_range(0, lastnames.size() - 1)]

func generate_specialties():
	var pool = SPECIALTIES_GB if position1 == "GB" else SPECIALTIES_FIELD
	var roll = randi_range(1, 100)
	if roll <= 90:
		specialty1 = ""
		specialty2 = ""
	elif roll <= 99:
		specialty1 = pool[randi_range(0, pool.size() - 1)]
		specialty2 = ""
	else:
		specialty1 = pool[randi_range(0, pool.size() - 1)]
		if pool.size() > 1:
			var s2 = specialty1
			while s2 == specialty1:
				s2 = pool[randi_range(0, pool.size() - 1)]
			specialty2 = s2
		else:
			specialty2 = ""

func generate_skills():
	var base_value = note / 10
	var remainder = note - (base_value * 10)
	strength = base_value
	speed = base_value
	aggression = base_value
	positioning = base_value
	stamina = base_value
	creativity = base_value
	concentration = base_value
	motivation = base_value
	anticipation = base_value
	communication = base_value
	var v1 = randi_range(-3, 3)
	strength += v1
	speed -= v1
	var v2 = randi_range(-3, 3)
	positioning += v2
	anticipation -= v2
	var v3 = randi_range(-3, 3)
	aggression += v3
	communication -= v3
	var v4 = randi_range(-3, 3)
	stamina += v4
	motivation -= v4
	var v5 = randi_range(-3, 3)
	creativity += v5
	concentration -= v5
	for i in range(remainder):
		var idx = randi_range(0, 9)
		match idx:
			0: strength += 1
			1: speed += 1
			2: positioning += 1
			3: aggression += 1
			4: stamina += 1
			5: creativity += 1
			6: concentration += 1
			7: motivation += 1
			8: anticipation += 1
			9: communication += 1

# --- AFFICHAGE ---
func display():
	if color == "":
		return
	card_background.modulate = CARD_COLORS[color]
	txt_note.text = str(note)
	txt_position1.text = position1
	if position2 != "" and position2_unlocked == 1:
		txt_position2.text = position2
		txt_position2.visible = true
	else:
		txt_position2.visible = false
	txt_firstname.text = firstname
	txt_lastname.text = lastname
	btn_pincolor.visible = (pin_color != "")
	img_specialty1.visible = (specialty1 != "")
	img_specialty2.visible = (specialty2 != "")
	if specialty1 != "":
		var path1 = "res://Sprites/Specialties/specialty_" + specialty1 + ".png"
		var tex1 = load(path1) if ResourceLoader.exists(path1) else null
		img_specialty1.texture = tex1
	if specialty2 != "":
		var path2 = "res://Sprites/Specialties/specialty_" + specialty2 + ".png"
		var tex2 = load(path2) if ResourceLoader.exists(path2) else null
		img_specialty2.texture = tex2
	var flag_path = "res://Sprites/Flags/flag_" + nationality + ".png"
	var tex = load(flag_path) if ResourceLoader.exists(flag_path) else null
	img_flag.texture = tex
	img_flag.visible = tex != null

# --- CLIC ---
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var local_pos = to_local(event.position)
			if $CardBackground.get_rect().has_point(local_pos):
				_on_card_clicked()

func _on_card_clicked():
	if not clickable:
		return
	GameState.selected_note = note
	GameState.selected_color = color
	GameState.selected_position1 = position1
	GameState.selected_position2 = position2
	GameState.selected_position2_unlocked = position2_unlocked
	GameState.selected_age = age
	GameState.selected_height = height
	GameState.selected_weight = weight
	GameState.selected_nationality = nationality
	GameState.selected_specialty1 = specialty1
	GameState.selected_specialty2 = specialty2
	GameState.selected_firstname = firstname
	GameState.selected_lastname = lastname
	GameState.selected_pin_color = pin_color
	GameState.selected_strength = strength
	GameState.selected_speed = speed
	GameState.selected_aggression = aggression
	GameState.selected_positioning = positioning
	GameState.selected_stamina = stamina
	GameState.selected_creativity = creativity
	GameState.selected_concentration = concentration
	GameState.selected_motivation = motivation
	GameState.selected_anticipation = anticipation
	GameState.selected_communication = communication
	GameState.selected_deco_index = deco_index
	GameState.previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scenes/detail_card_player.tscn")

# --- SAUVEGARDE / RESTAURATION DECO ---
func save_to_gamestate_deco1():
	GameState.deco1_note = note
	GameState.deco1_color = color
	GameState.deco1_position1 = position1
	GameState.deco1_position2 = position2
	GameState.deco1_position2_unlocked = position2_unlocked
	GameState.deco1_age = age
	GameState.deco1_height = height
	GameState.deco1_weight = weight
	GameState.deco1_nationality = nationality
	GameState.deco1_specialty1 = specialty1
	GameState.deco1_specialty2 = specialty2
	GameState.deco1_firstname = firstname
	GameState.deco1_lastname = lastname
	GameState.deco1_pin_color = pin_color
	GameState.deco1_strength = strength
	GameState.deco1_speed = speed
	GameState.deco1_aggression = aggression
	GameState.deco1_positioning = positioning
	GameState.deco1_stamina = stamina
	GameState.deco1_creativity = creativity
	GameState.deco1_concentration = concentration
	GameState.deco1_motivation = motivation
	GameState.deco1_anticipation = anticipation
	GameState.deco1_communication = communication

func save_to_gamestate_deco2():
	GameState.deco2_note = note
	GameState.deco2_color = color
	GameState.deco2_position1 = position1
	GameState.deco2_position2 = position2
	GameState.deco2_position2_unlocked = position2_unlocked
	GameState.deco2_age = age
	GameState.deco2_height = height
	GameState.deco2_weight = weight
	GameState.deco2_nationality = nationality
	GameState.deco2_specialty1 = specialty1
	GameState.deco2_specialty2 = specialty2
	GameState.deco2_firstname = firstname
	GameState.deco2_lastname = lastname
	GameState.deco2_pin_color = pin_color
	GameState.deco2_strength = strength
	GameState.deco2_speed = speed
	GameState.deco2_aggression = aggression
	GameState.deco2_positioning = positioning
	GameState.deco2_stamina = stamina
	GameState.deco2_creativity = creativity
	GameState.deco2_concentration = concentration
	GameState.deco2_motivation = motivation
	GameState.deco2_anticipation = anticipation
	GameState.deco2_communication = communication

func restore_from_gamestate_deco1():
	note = GameState.deco1_note
	color = GameState.deco1_color
	position1 = GameState.deco1_position1
	position2 = GameState.deco1_position2
	position2_unlocked = GameState.deco1_position2_unlocked
	age = GameState.deco1_age
	height = GameState.deco1_height
	weight = GameState.deco1_weight
	nationality = GameState.deco1_nationality
	specialty1 = GameState.deco1_specialty1
	specialty2 = GameState.deco1_specialty2
	firstname = GameState.deco1_firstname
	lastname = GameState.deco1_lastname
	pin_color = GameState.deco1_pin_color
	strength = GameState.deco1_strength
	speed = GameState.deco1_speed
	aggression = GameState.deco1_aggression
	positioning = GameState.deco1_positioning
	stamina = GameState.deco1_stamina
	creativity = GameState.deco1_creativity
	concentration = GameState.deco1_concentration
	motivation = GameState.deco1_motivation
	anticipation = GameState.deco1_anticipation
	communication = GameState.deco1_communication

func restore_from_gamestate_deco2():
	note = GameState.deco2_note
	color = GameState.deco2_color
	position1 = GameState.deco2_position1
	position2 = GameState.deco2_position2
	position2_unlocked = GameState.deco2_position2_unlocked
	age = GameState.deco2_age
	height = GameState.deco2_height
	weight = GameState.deco2_weight
	nationality = GameState.deco2_nationality
	specialty1 = GameState.deco2_specialty1
	specialty2 = GameState.deco2_specialty2
	firstname = GameState.deco2_firstname
	lastname = GameState.deco2_lastname
	pin_color = GameState.deco2_pin_color
	strength = GameState.deco2_strength
	speed = GameState.deco2_speed
	aggression = GameState.deco2_aggression
	positioning = GameState.deco2_positioning
	stamina = GameState.deco2_stamina
	creativity = GameState.deco2_creativity
	concentration = GameState.deco2_concentration
	motivation = GameState.deco2_motivation
	anticipation = GameState.deco2_anticipation
	communication = GameState.deco2_communication
