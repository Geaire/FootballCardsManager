extends Node2D

# --- NOEUDS ---
@onready var card_preview = $CardPreview
@onready var card_background_skills = $Skills/CardBackgroundSkills
@onready var txt_strength_value = $Skills/TXT_StrengthValue
@onready var txt_speed_value = $Skills/TXT_SpeedValue
@onready var txt_aggression_value = $Skills/TXT_AggressionValue
@onready var txt_positioning_value = $Skills/TXT_PositioningValue
@onready var txt_stamina_value = $Skills/TXT_StaminaValue
@onready var txt_concentration_value = $Skills/TXT_ConcentrationValue
@onready var txt_communication_value = $Skills/TXT_CommunicationValue
@onready var txt_motivation_value = $Skills/TXT_MotivationValue
@onready var txt_creativity_value = $Skills/TXT_CreativityValue
@onready var txt_anticipation_value = $Skills/TXT_AnticipationValue
@onready var txt_age_value = $Physical/TXT_AgeValue
@onready var txt_height_value = $Physical/TXT_HeightValue
@onready var txt_weight_value = $Physical/TXT_WeightValue
@onready var btn_rename = $"Player Evolution/BTN_Rename"
@onready var btn_position2 = $"Player Evolution/BTN_AttributePosition2"
@onready var btn_specialty1 = $"Player Evolution/BTN_AttributeSpecialty1"
@onready var btn_specialty2 = $"Player Evolution/BTN_AttributeSpecialty2"
@onready var btn_pincolor = $"Player Evolution/BTN_AttributePinColor"
@onready var txt_rename_firstname = $"Player Evolution/TXT_RenameFirstName"
@onready var txt_rename_lastname = $"Player Evolution/TXT_RenameLastName"

# --- COULEURS BOUTONS ---
const BTN_GREEN = Color(0.0, 0.8, 0.0)
const BTN_RED = Color(0.8, 0.0, 0.0)
const BTN_ORANGE = Color(1.0, 0.5, 0.0)

# --- VARIABLES MANAGER ---
var manager_position2_stock: int = 0
var manager_specialty_stock: int = 0

# --- READY ---
func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	setup()

func setup():
	if GameState.selected_color == "":
		return
	var cp = card_preview
	cp.clickable = false

	# Injecter les données GameState dans CardPreview
	cp.note = GameState.selected_note
	cp.color = GameState.selected_color
	cp.position1 = GameState.selected_position1
	cp.position2 = GameState.selected_position2
	cp.position2_unlocked = GameState.selected_position2_unlocked
	cp.firstname = GameState.selected_firstname
	cp.lastname = GameState.selected_lastname
	cp.nationality = GameState.selected_nationality
	cp.specialty1 = GameState.selected_specialty1
	cp.specialty2 = GameState.selected_specialty2
	cp.pin_color = GameState.selected_pin_color
	cp.display()

	# Panneau Skills
	card_background_skills.modulate = cp.CARD_COLORS[cp.color]
	txt_strength_value.text = str(GameState.selected_strength)
	txt_speed_value.text = str(GameState.selected_speed)
	txt_aggression_value.text = str(GameState.selected_aggression)
	txt_positioning_value.text = str(GameState.selected_positioning)
	txt_stamina_value.text = str(GameState.selected_stamina)
	txt_concentration_value.text = str(GameState.selected_concentration)
	txt_communication_value.text = str(GameState.selected_communication)
	txt_motivation_value.text = str(GameState.selected_motivation)
	txt_creativity_value.text = str(GameState.selected_creativity)
	txt_anticipation_value.text = str(GameState.selected_anticipation)

	# Panneau Physical
	txt_age_value.text = str(GameState.selected_age)
	txt_height_value.text = str(GameState.selected_height)
	txt_weight_value.text = str(GameState.selected_weight)

	# Noms pour Rename
	txt_rename_firstname.text = GameState.selected_firstname
	txt_rename_lastname.text = GameState.selected_lastname

	setup_buttons(cp)

func setup_buttons(cp):
	if cp.color in ["blue", "white", "special"]:
		btn_rename.modulate = BTN_GREEN
	else:
		btn_rename.modulate = BTN_RED

	if manager_position2_stock > 0:
		btn_position2.modulate = BTN_GREEN
	else:
		btn_position2.modulate = BTN_RED

	if manager_specialty_stock > 0:
		btn_specialty1.modulate = BTN_GREEN
		btn_specialty2.modulate = BTN_GREEN
	else:
		btn_specialty1.modulate = BTN_RED
		btn_specialty2.modulate = BTN_RED

	btn_pincolor.modulate = BTN_GREEN
