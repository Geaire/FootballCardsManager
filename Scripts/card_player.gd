extends Node2D

# ---- NOEUDS ----
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

# ---- DONNEES ----
var note: int
var color: String
var position1: String
var position2: String = ""
var position2_unlocked: int = 0
var age: int
var height: int
var weight: int
var nationality: int
var specialty1: String = ""
var specialty2: String = ""
var firstname: String
var lastname: String
var pin_color: String = ""

const POSITIONS = ["GB","DG","DD","DC","MG","MD","MDF","MC","MO","AG","AD","AC","ATT"]

const CARD_COLORS = {
	"Yellow": Color(1.0, 0.85, 0.0),
	"Orange": Color(1.0, 0.5, 0.0),
	"Red": Color(0.9, 0.1, 0.1),
	"Magenta": Color(0.56, 0.016, 0.56),
	"Blue": Color(0.2, 0.5, 1.0),
	"White": Color(1.0, 1.0, 1.0)
}

func _ready():
	position = Vector2(960, 540)
	generate()
	display()

func generate():
	generate_note_and_color()
	generate_age_height_weight()
	generate_nationality()
	generate_positions()
	generate_name()
	generate_specialties()

func generate_note_and_color():
	var roll = randi_range(1, 100)
	if roll <= 40:
		note = randi_range(60, 69)
		color = "Yellow"
	elif roll <= 65:
		note = randi_range(70, 79)
		color = "Orange"
	elif roll <= 82:
		note = randi_range(80, 89)
		color = "Red"
	elif roll <= 93:
		note = randi_range(90, 99)
		color = "Magenta"
	else:
		note = randi_range(100, 129)
		color = "Blue"

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
	if roll <= 50:
		nationality = randi_range(0, 7)
	else:
		nationality = randi_range(8, 77)

func generate_positions():
	position1 = POSITIONS[randi_range(0, 12)]
	var roll = randi_range(1, 100)
	if roll <= 5 and position1 != "GB":
		var pos2 = position1
		while pos2 == position1 or pos2 == "GB":
			pos2 = POSITIONS[randi_range(0, 12)]
		position2 = pos2
	else:
		position2 = ""

func generate_name():
	firstname = "First Name"
	lastname = "Last Name"

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
