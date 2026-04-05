extends Node2D

# ----- NOEUDS -----
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

# ----- DONNEES -----
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

# ----- CONSTANTES -----
const POSITIONS = ["GB","DG","DD","DC","MG","MD","MDF","MC","MOC","AG","AD","AC","ATT"]

const CARD_COLORS = {
	"yellow": Color(1.0, 0.85, 0.0),
	"orange": Color(1.0, 0.5, 0.0),
	"red": Color(0.9, 0.1, 0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"blue": Color(0.2, 0.5, 1.0),
	"white": Color(1.0, 1.0, 1.0)
}

# 🌍 PAYS

# 40%
const TOP_COUNTRIES = ["br", "de", "ar", "fr", "it", "es", "gb"]

# 30%
const STRONG_COUNTRIES = ["nl", "be", "hr", "pt", "ma", "pl", "se"]

# 30%
const OTHER_COUNTRIES = [
	"us","mx","ca","jp","kr","au","ch","at","dk","no","fi","cz","sk","hu",
	"ro","bg","gr","tr","ua","rs","si","is","ie","za","eg","dz","tn","ng",
	"cm","ci","gh","sn","ml","ir","iq","sa","ae","qa","kw","cl","pe","co",
	"ve","ec","py","bo","uy","cr","hn","pa"
]

# 🌍 LIEN PAYS → FICHIERS NOMS
const COUNTRY_TO_NAME_FILE = {
	"fr": "res://Data/Names/names_french.json",
	"br": "res://Data/Names/names_portuguese.json",
	"pt": "res://Data/Names/names_portuguese.json",
	"es": "res://Data/Names/names_spanish.json",
	"ar": "res://Data/Names/names_spanish.json",
	"it": "res://Data/Names/names_italian.json",
	"de": "res://Data/Names/names_german.json",
	"gb": "res://Data/Names/names_english.json",

	"nl": "res://Data/Names/names_german.json",
	"be": "res://Data/Names/names_french.json",
	"hr": "res://Data/Names/names_slavic.json",
	"pl": "res://Data/Names/names_slavic.json",
	"se": "res://Data/Names/names_scandinavian.json",

	"ma": "res://Data/Names/names_arabic.json",
	"dz": "res://Data/Names/names_arabic.json",
	"tn": "res://Data/Names/names_arabic.json",

	"default": "res://Data/Names/names_english.json"
}

# ----- READY -----
func _ready():
	position = get_viewport_rect().size / 2
	generate()
	display()

# ----- GENERATION -----
func generate():
	generate_note_and_color()
	generate_age_height_weight()
	generate_nationality()
	generate_positions()
	generate_name()
	generate_specialties()

# ----- NOTE / COULEUR -----
func generate_note_and_color():
	var roll = randi_range(1, 100)

	if roll <= 40:
		note = randi_range(60, 69)
		color = "yellow"
	elif roll <= 65:
		note = randi_range(70, 79)
		color = "orange"
	elif roll <= 82:
		note = randi_range(80, 89)
		color = "red"
	elif roll <= 93:
		note = randi_range(90, 99)
		color = "magenta"
	else:
		note = randi_range(100, 129)
		color = "blue"

# ----- PHYSIQUE -----
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

# ----- NATIONALITE -----
func generate_nationality():
	var roll = randi_range(1, 100)

	if roll <= 40:
		nationality = TOP_COUNTRIES[randi_range(0, TOP_COUNTRIES.size() - 1)]
	elif roll <= 70:
		nationality = STRONG_COUNTRIES[randi_range(0, STRONG_COUNTRIES.size() - 1)]
	else:
		nationality = OTHER_COUNTRIES[randi_range(0, OTHER_COUNTRIES.size() - 1)]

# ----- POSITIONS -----
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

# ----- NOM DYNAMIQUE -----
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

# ----- SPECIALITES -----
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

# ----- AFFICHAGE -----
func display():
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

	# 🇫🇷 DRAPEAU
	img_flag.texture = load("res://Sprites/Flags/flag_" + nationality + ".png")
