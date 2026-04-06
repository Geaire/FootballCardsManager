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
@onready var lineedit_firstname = $"Player Evolution/LineEdit_FirstName"
@onready var lineedit_lastname = $"Player Evolution/LineEdit_LastName"
@onready var btn_pin_yellow = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinYellow"
@onready var btn_pin_orange = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinOrange"
@onready var btn_pin_red = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinRed"
@onready var btn_pin_purple = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinPurple"
@onready var btn_pin_blue = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinBlue"
@onready var btn_pin_green = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinGreen"
@onready var btn_pin_white = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinWhite"
@onready var btn_pin_black = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePinBlack"

# --- COULEURS BOUTONS ---
const BTN_GREEN = Color(0.0, 0.8, 0.0)
const BTN_RED = Color(0.8, 0.0, 0.0)

# --- COULEURS PIN ---
const PIN_COLORS = {
	"yellow": Color(1.0, 0.85, 0.0),
	"orange": Color(1.0, 0.5, 0.0),
	"red": Color(0.9, 0.1, 0.1),
	"purple": Color(0.56, 0.016, 0.56),
	"blue": Color(0.2, 0.5, 1.0),
	"green": Color(0.0, 0.8, 0.0),
	"white": Color(1.0, 1.0, 1.0),
	"black": Color(0.05, 0.05, 0.05)
}

# --- VARIABLES ---
var manager_position2_stock: int = 0
var manager_specialty_stock: int = 0
var rename_mode: bool = false
var pin_menu_open: bool = false

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

	txt_age_value.text = str(GameState.selected_age)
	txt_height_value.text = str(GameState.selected_height)
	txt_weight_value.text = str(GameState.selected_weight)

	txt_rename_firstname.text = GameState.selected_firstname
	txt_rename_lastname.text = GameState.selected_lastname

	lineedit_firstname.visible = false
	lineedit_lastname.visible = false

	# Coloriser les 8 pins
	btn_pin_yellow.modulate = PIN_COLORS["yellow"]
	btn_pin_orange.modulate = PIN_COLORS["orange"]
	btn_pin_red.modulate = PIN_COLORS["red"]
	btn_pin_purple.modulate = PIN_COLORS["purple"]
	btn_pin_blue.modulate = PIN_COLORS["blue"]
	btn_pin_green.modulate = PIN_COLORS["green"]
	btn_pin_white.modulate = PIN_COLORS["white"]
	btn_pin_black.modulate = PIN_COLORS["black"]

	# Pin menu fermé + bouton toggle blanc
	_set_pin_menu_visible(false)
	btn_pincolor.modulate = Color(1.0, 1.0, 1.0)

	lineedit_firstname.text_submitted.connect(_on_firstname_submitted)
	lineedit_lastname.text_submitted.connect(_on_lastname_submitted)

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

# --- PIN COLOR ---
func _set_pin_menu_visible(value: bool):
	btn_pin_yellow.visible = value
	btn_pin_orange.visible = value
	btn_pin_red.visible = value
	btn_pin_purple.visible = value
	btn_pin_blue.visible = value
	btn_pin_green.visible = value
	btn_pin_white.visible = value
	btn_pin_black.visible = value

func _apply_pin_color(color_key: String):
	card_preview.btn_pincolor.modulate = PIN_COLORS[color_key]
	card_preview.btn_pincolor.visible = true
	card_preview.pin_color = color_key
	GameState.selected_pin_color = color_key
	pin_menu_open = false
	_set_pin_menu_visible(false)

# --- RENAME ---
func _enter_rename_mode():
	rename_mode = true
	lineedit_firstname.text = GameState.selected_firstname
	lineedit_lastname.text = GameState.selected_lastname
	txt_rename_firstname.visible = false
	txt_rename_lastname.visible = false
	lineedit_firstname.visible = true
	lineedit_lastname.visible = true
	lineedit_firstname.grab_focus()

func _on_firstname_submitted(new_text: String):
	GameState.selected_firstname = new_text
	txt_rename_firstname.text = new_text
	card_preview.firstname = new_text
	card_preview.display()
	lineedit_lastname.grab_focus()

func _on_lastname_submitted(new_text: String):
	GameState.selected_lastname = new_text
	txt_rename_lastname.text = new_text
	card_preview.lastname = new_text
	card_preview.display()
	_exit_rename_mode()

func _exit_rename_mode():
	rename_mode = false
	lineedit_firstname.visible = false
	lineedit_lastname.visible = false
	txt_rename_firstname.visible = true
	txt_rename_lastname.visible = true

# --- INPUT ---
func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var pos = event.position

	if _sprite_hit(btn_rename, pos):
		if card_preview.color in ["blue", "white", "special"]:
			_enter_rename_mode()
		return

	if _sprite_hit(btn_pincolor, pos):
		if pin_menu_open:
			pin_menu_open = false
			_set_pin_menu_visible(false)
		else:
			pin_menu_open = true
			_set_pin_menu_visible(true)
		return

	if pin_menu_open:
		if _sprite_hit(btn_pin_yellow, pos):
			_apply_pin_color("yellow")
		elif _sprite_hit(btn_pin_orange, pos):
			_apply_pin_color("orange")
		elif _sprite_hit(btn_pin_red, pos):
			_apply_pin_color("red")
		elif _sprite_hit(btn_pin_purple, pos):
			_apply_pin_color("purple")
		elif _sprite_hit(btn_pin_blue, pos):
			_apply_pin_color("blue")
		elif _sprite_hit(btn_pin_green, pos):
			_apply_pin_color("green")
		elif _sprite_hit(btn_pin_white, pos):
			_apply_pin_color("white")
		elif _sprite_hit(btn_pin_black, pos):
			_apply_pin_color("black")
		return

# --- UTILITAIRES ---
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
