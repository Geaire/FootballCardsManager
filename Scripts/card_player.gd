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
var color: String
var position1: String
var position2: String = ""
var position2_unlocked: int = 0
var age: int
var height: int
var weight: int
var nationality: String
var specialty1: String = ""
var specialty2: String = ""
var firstname: String
var lastname: String
var pin_color: String = ""
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

const TOP_COUNTRIES = ["br","de","ar","fr","it","es","gb","pt"]
const STRONG_COUNTRIES = ["nl","be","hr","pl","se","ma","sn","gh","ng","us","mx","jp","kr","au"]
const OTHER_COUNTRIES = [
	"ca","ch","at","dk","no","fi","cz","sk","hu",
	"ro","bg","gr","tr","ua","rs","si","ie","za",
	"eg","dz","tn","cm","ci","ml","ir","iq","sa",
	"qa","kw","cl","pe","co","ve","ec","py","bo",
	"uy","cr","hn","pa","cn","ru","is"
]

const COUNTRY_TO_NAME_FILE = {
	"fr": "res://Data/Names/names_french.json",
	"be": "res://Data/Names/names_french.json",
	"ch": "res://Data/Names/names_french.json",
	"br": "res://Data/Names/names_portuguese.json",
	"pt": "res://Data/Names/names_portuguese.json",
	"es": "res://Data/Names/names_spanish.json",
	"ar": "res://Data/Names/names_spanish.json",
	"mx": "res://Data/Names/names_spanish.json",
	"cl": "res://Data/Names/names_spanish.json",
	"co": "res://Data/Names/names_spanish.json",
	"pe": "res://Data/Names/names_spanish.json",
	"ve": "res://Data/Names/names_spanish.json",
	"ec": "res://Data/Names/names_spanish.json",
	"py": "res://Data/Names/names_spanish.json",
	"bo": "res://Data/Names/names_spanish.json",
	"uy": "res://Data/Names/names_spanish.json",
	"cr": "res://Data/Names/names_spanish.json",
	"hn": "res://Data/Names/names_spanish.json",
	"pa": "res://Data/Names/names_spanish.json",
	"it": "res://Data/Names/names_italian.json",
	"de": "res://Data/Names/names_german.json",
	"at": "res://Data/Names/names_german.json",
	"nl": "res://Data/Names/names_german.json",
	"gb": "res://Data/Names/names_english.json",
	"us": "res://Data/Names/names_english.json",
	"au": "res://Data/Names/names_english.json",
	"ie": "res://Data/Names/names_english.json",
	"hr": "res://Data/Names/names_slavic.json",
	"pl": "res://Data/Names/names_slavic.json",
	"ru": "res://Data/Names/names_slavic.json",
	"ua": "res://Data/Names/names_slavic.json",
	"rs": "res://Data/Names/names_slavic.json",
	"si": "res://Data/Names/names_slavic.json",
	"cz": "res://Data/Names/names_slavic.json",
	"sk": "res://Data/Names/names_slavic.json",
	"bg": "res://Data/Names/names_slavic.json",
	"ro": "res://Data/Names/names_slavic.json",
	"se": "res://Data/Names/names_scandinavian.json",
	"dk": "res://Data/Names/names_scandinavian.json",
	"no": "res://Data/Names/names_scandinavian.json",
	"fi": "res://Data/Names/names_scandinavian.json",
	"is": "res://Data/Names/names_scandinavian.json",
	"ma": "res://Data/Names/names_arabic.json",
	"dz": "res://Data/Names/names_arabic.json",
	"tn": "res://Data/Names/names_arabic.json",
	"eg": "res://Data/Names/names_arabic.json",
	"sa": "res://Data/Names/names_arabic.json",
	"qa": "res://Data/Names/names_arabic.json",
	"kw": "res://Data/Names/names_arabic.json",
	"iq": "res://Data/Names/names_arabic.json",
	"ir": "res://Data/Names/names_persian.json",
	"sn": "res://Data/Names/names_african.json",
	"gh": "res://Data/Names/names_african.json",
	"ng": "res://Data/Names/names_african.json",
	"cm": "res://Data/Names/names_african.json",
	"ci": "res://Data/Names/names_african.json",
	"ml": "res://Data/Names/names_african.json",
	"za": "res://Data/Names/names_african.json",
	"jp": "res://Data/Names/names_asian.json",
	"kr": "res://Data/Names/names_asian.json",
	"cn": "res://Data/Names/names_asian.json",
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
	var roll = randi_range(1, 100)
	if roll <= 5 and position1 != "GB":
		var pos2 = position1
		while pos2 == position1 or pos2 == "GB":
			pos2 = POSITIONS[randi_range(0, POSITIONS.size() - 1)]
		position2 = pos2
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
	var roll = randi_range(1, 100)
	if roll <= 15:
		specialty1 = "tir"
		var roll2 = randi_range(1, 100)
		if roll2 <= 33:
			specialty2 = "dribble"
		else:
			specialty2 = ""
	else:
		specialty1 = ""
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
	get_tree().change_scene_to_file("res://Scenes/detail_card_player.tscn")
