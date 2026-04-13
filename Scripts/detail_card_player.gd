extends Node2D

const TRANSLATIONS_DCP = {
	"fr": {"rename": "Renommer joueur", "position2": "Attribuer poste 2", "specialty1": "Attribuer spécialité 1", "specialty2": "Attribuer spécialité 2", "pincolor": "Attribuer épingle de couleur", "achievements": "Historique"},
	"en": {"rename": "Rename player", "position2": "Assign position 2", "specialty1": "Assign specialty 1", "specialty2": "Assign specialty 2", "pincolor": "Assign color pin", "achievements": "History"},
	"es": {"rename": "Renombrar jugador", "position2": "Asignar posición 2", "specialty1": "Asignar especialidad 1", "specialty2": "Asignar especialidad 2", "pincolor": "Asignar pin de color", "achievements": "Historial"},
	"de": {"rename": "Spieler umbenennen", "position2": "Position 2 zuweisen", "specialty1": "Spezialität 1 zuweisen", "specialty2": "Spezialität 2 zuweisen", "pincolor": "Farbpin zuweisen", "achievements": "Verlauf"},
	"it": {"rename": "Rinomina giocatore", "position2": "Assegna posizione 2", "specialty1": "Assegna specialità 1", "specialty2": "Assegna specialità 2", "pincolor": "Assegna pin colore", "achievements": "Storico"},
	"pt": {"rename": "Renomear jogador", "position2": "Atribuir posição 2", "specialty1": "Atribuir especialidade 1", "specialty2": "Atribuir especialidade 2", "pincolor": "Atribuir pin de cor", "achievements": "Histórico"}
}

const BTN_GREEN = Color(0.0, 0.8, 0.2)
const BTN_RED   = Color(0.9, 0.1, 0.1)
const BTN_WHITE = Color(1.0, 1.0, 1.0)

const PIN_COLORS = {
	"cyan":     Color(0.0,   0.808, 0.820),
	"marine":   Color(0.0,   0.200, 0.400),
	"rose":     Color(1.0,   0.412, 0.706),
	"violet":   Color(0.416, 0.051, 0.678),
	"gris":     Color(0.722, 0.722, 0.722),
	"marron":   Color(0.545, 0.271, 0.075),
	"rouge":    Color(1.0,   0.420, 0.420),
	"bordeaux": Color(0.502, 0.0,   0.125),
	"vertclair":Color(0.584, 0.835, 0.698),
	"vertfonce":Color(0.176, 0.416, 0.310)
}

var manager_position2_stock: int = 0
var manager_specialty_stock: int = 0
var pin_menu_open: bool = false
var rename_mode: String = ""

@onready var card_preview            = $CardPreview
@onready var btn_close               = $BTN_CloseDetailCardPlayer
@onready var txt_strength_value      = $Skills/TXT_StrengthValue
@onready var txt_speed_value         = $Skills/TXT_SpeedValue
@onready var txt_aggression_value    = $Skills/TXT_AggressionValue
@onready var txt_positioning_value   = $Skills/TXT_PositioningValue
@onready var txt_stamina_value       = $Skills/TXT_StaminaValue
@onready var txt_concentration_value = $Skills/TXT_ConcentrationValue
@onready var txt_communication_value = $Skills/TXT_CommunicationValue
@onready var txt_motivation_value    = $Skills/TXT_MotivationValue
@onready var txt_creativity_value    = $Skills/TXT_CreativityValue
@onready var txt_anticipation_value  = $Skills/TXT_AnticipationValue
@onready var txt_age_value           = $Physical/TXT_AgeValue
@onready var txt_height_value        = $Physical/TXT_HeightValue
@onready var txt_weight_value        = $Physical/TXT_WeightValue
@onready var btn_rename              = $"Player Evolution/BTN_Rename"
@onready var btn_position2           = $"Player Evolution/BTN_AttributePosition2"
@onready var btn_specialty1          = $"Player Evolution/BTN_AttributeSpecialty1"
@onready var btn_specialty2          = $"Player Evolution/BTN_AttributeSpecialty2"
@onready var btn_pincolor            = $"Player Evolution/BTN_AttributePinColor"
@onready var txt_rename              = $"Player Evolution/TXT_Rename"
@onready var txt_pos2_label          = $"Player Evolution/TXT_AttributePosition2"
@onready var txt_spec1_label         = $"Player Evolution/TXT_AttributeSpecialty1"
@onready var txt_spec2_label         = $"Player Evolution/TXT_AttributeSpecialty2"
@onready var txt_attribute_pincolor  = $"Player Evolution/TXT_AttributePinColor"
@onready var txt_rename_firstname    = $"Player Evolution/TXT_RenameFirstName"
@onready var txt_rename_lastname     = $"Player Evolution/TXT_RenameLastName"
@onready var lineedit_firstname      = $"Player Evolution/LineEdit_FirstName"
@onready var lineedit_lastname       = $"Player Evolution/LineEdit_LastName"
@onready var btn_pin_cyan      = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#00CED1"
@onready var btn_pin_marine    = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#003366"
@onready var btn_pin_rose      = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#FF69B4"
@onready var btn_pin_violet    = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#6A0DAD"
@onready var btn_pin_gris      = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#B8B8B8"
@onready var btn_pin_marron    = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#8B4513"
@onready var btn_pin_rouge     = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#FF6B6B"
@onready var btn_pin_bordeaux  = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#800020"
@onready var btn_pin_vertclair = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#95D5B2"
@onready var btn_pin_vertfonce = $"Player Evolution/BTN_AttributePinColor/BTN_AttributePin#2D6A4F"
@onready var txt_achievements  = $TXT_Achievements

func _ready():
	var cp = card_preview
	cp.note = GameState.selected_note; cp.color = GameState.selected_color
	cp.position1 = GameState.selected_position1; cp.position2 = GameState.selected_position2
	cp.position2_unlocked = GameState.selected_position2_unlocked
	cp.age = GameState.selected_age; cp.height = GameState.selected_height; cp.weight = GameState.selected_weight
	cp.nationality = GameState.selected_nationality
	cp.specialty1 = GameState.selected_specialty1; cp.specialty2 = GameState.selected_specialty2
	cp.firstname = GameState.selected_firstname; cp.lastname = GameState.selected_lastname
	cp.pin_color = GameState.selected_pin_color
	cp.strength = GameState.selected_strength; cp.speed = GameState.selected_speed
	cp.aggression = GameState.selected_aggression; cp.positioning = GameState.selected_positioning
	cp.stamina = GameState.selected_stamina; cp.creativity = GameState.selected_creativity
	cp.concentration = GameState.selected_concentration; cp.motivation = GameState.selected_motivation
	cp.anticipation = GameState.selected_anticipation; cp.communication = GameState.selected_communication
	cp.clickable = false
	cp.display()
	lineedit_firstname.visible = false; lineedit_lastname.visible = false
	_setup_pin_colors()
	_set_pin_menu_visible(false)
	lineedit_firstname.text_submitted.connect(_on_firstname_submitted)
	lineedit_lastname.text_submitted.connect(_on_lastname_submitted)
	_apply_translations()
	setup_buttons(cp)

func _setup_pin_colors():
	btn_pin_cyan.modulate      = PIN_COLORS["cyan"]
	btn_pin_marine.modulate    = PIN_COLORS["marine"]
	btn_pin_rose.modulate      = PIN_COLORS["rose"]
	btn_pin_violet.modulate    = PIN_COLORS["violet"]
	btn_pin_gris.modulate      = PIN_COLORS["gris"]
	btn_pin_marron.modulate    = PIN_COLORS["marron"]
	btn_pin_rouge.modulate     = PIN_COLORS["rouge"]
	btn_pin_bordeaux.modulate  = PIN_COLORS["bordeaux"]
	btn_pin_vertclair.modulate = PIN_COLORS["vertclair"]
	btn_pin_vertfonce.modulate = PIN_COLORS["vertfonce"]

func _apply_translations():
	var t = TRANSLATIONS_DCP[GameState.language]
	txt_rename.text = t["rename"]; txt_pos2_label.text = t["position2"]
	txt_spec1_label.text = t["specialty1"]; txt_spec2_label.text = t["specialty2"]
	txt_attribute_pincolor.text = t["pincolor"]; txt_achievements.text = t["achievements"]

func setup_buttons(cp):
	btn_rename.modulate   = BTN_GREEN if cp.color in ["blue","white","special"] else BTN_RED
	btn_position2.modulate = BTN_GREEN if manager_position2_stock > 0 else BTN_RED
	btn_specialty1.modulate = BTN_GREEN if manager_specialty_stock > 0 else BTN_RED
	btn_specialty2.modulate = BTN_GREEN if manager_specialty_stock > 0 else BTN_RED
	btn_pincolor.modulate = BTN_WHITE

func _set_pin_menu_visible(value: bool):
	btn_pin_cyan.visible = value; btn_pin_marine.visible = value
	btn_pin_rose.visible = value; btn_pin_violet.visible = value
	btn_pin_gris.visible = value; btn_pin_marron.visible = value
	btn_pin_rouge.visible = value; btn_pin_bordeaux.visible = value
	btn_pin_vertclair.visible = value; btn_pin_vertfonce.visible = value

func _apply_pin_color(key: String):
	card_preview.pin_color = key
	card_preview.btn_pincolor.modulate = PIN_COLORS[key]
	card_preview.btn_pincolor.visible = true
	pin_menu_open = false; _set_pin_menu_visible(false)

func _remove_pin():
	card_preview.pin_color = ""; card_preview.btn_pincolor.visible = false
	pin_menu_open = false; _set_pin_menu_visible(false)

func _enter_rename_mode():
	lineedit_firstname.text = card_preview.firstname; lineedit_lastname.text = card_preview.lastname
	lineedit_firstname.visible = true; lineedit_lastname.visible = true
	lineedit_firstname.grab_focus(); rename_mode = "firstname"

func _on_firstname_submitted(text: String):
	card_preview.firstname = text.strip_edges()
	txt_rename_firstname.text = card_preview.firstname
	rename_mode = "lastname"; lineedit_lastname.grab_focus()

func _on_lastname_submitted(text: String):
	card_preview.lastname = text.strip_edges()
	txt_rename_lastname.text = card_preview.lastname
	lineedit_firstname.visible = false; lineedit_lastname.visible = false
	rename_mode = ""; card_preview.display()

func _save_changes_to_deco():
	if GameState.selected_deco_index == 1:
		GameState.deco1_firstname = card_preview.firstname
		GameState.deco1_lastname  = card_preview.lastname
		GameState.deco1_pin_color = card_preview.pin_color
	elif GameState.selected_deco_index == 2:
		GameState.deco2_firstname = card_preview.firstname
		GameState.deco2_lastname  = card_preview.lastname
		GameState.deco2_pin_color = card_preview.pin_color

func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if _sprite_hit(btn_close, pos):
		_save_changes_to_deco()
		get_tree().change_scene_to_file(GameState.previous_scene); return
	if _sprite_hit(btn_rename, pos):
		if card_preview.color in ["blue","white","special"]: _enter_rename_mode()
		return
	if _sprite_hit(btn_pincolor, pos):
		if pin_menu_open: _remove_pin()
		else: pin_menu_open = true; _set_pin_menu_visible(true)
		return
	if pin_menu_open:
		if _sprite_hit(btn_pin_cyan, pos):      _apply_pin_color("cyan")
		elif _sprite_hit(btn_pin_marine, pos):   _apply_pin_color("marine")
		elif _sprite_hit(btn_pin_rose, pos):     _apply_pin_color("rose")
		elif _sprite_hit(btn_pin_violet, pos):   _apply_pin_color("violet")
		elif _sprite_hit(btn_pin_gris, pos):     _apply_pin_color("gris")
		elif _sprite_hit(btn_pin_marron, pos):   _apply_pin_color("marron")
		elif _sprite_hit(btn_pin_rouge, pos):    _apply_pin_color("rouge")
		elif _sprite_hit(btn_pin_bordeaux, pos): _apply_pin_color("bordeaux")
		elif _sprite_hit(btn_pin_vertclair, pos):_apply_pin_color("vertclair")
		elif _sprite_hit(btn_pin_vertfonce, pos):_apply_pin_color("vertfonce")
		return

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
