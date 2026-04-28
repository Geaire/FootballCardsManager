extends Node2D

@onready var lineedit_manager  = $LineEdit_Manager
@onready var lineedit_team     = $LineEdit_TeamLabel
@onready var btn_confirm       = $BTN_Confirm
@onready var txt_error_manager = $TXT_IncorrectManager
@onready var txt_error_team    = $TXT_IncorrectTeam
@onready var txt_manager_label = $TXT_ManagerLabel
@onready var txt_team_label    = $TXT_TeamLabel
@onready var txt_confirm       = $TXT_Confirm

const MAX_NAME_LENGTH = 13
const SCENE_MAIN_MENU = "res://Scenes/main_menu.tscn"
const ALLOWED_CHARS   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-'"

const TRANSLATIONS = {
	"fr": {
		"manager": "Nom du manager", "team": "Nom de l'équipe", "confirm": "Confirmer",
		"err_mgr_empty": "Nom du manager : champ vide.", "err_mgr_length": "Nom du manager : 13 caractères maximum.",
		"err_mgr_chars": "Nom du manager : caractères non autorisés.", "err_team_empty": "Nom d'équipe : champ vide.",
		"err_team_length": "Nom d'équipe : 13 caractères maximum.", "err_team_chars": "Nom d'équipe : caractères non autorisés."
	},
	"en": {
		"manager": "Manager name", "team": "Team name", "confirm": "Confirm",
		"err_mgr_empty": "Manager name: empty field.", "err_mgr_length": "Manager name: 13 characters maximum.",
		"err_mgr_chars": "Manager name: invalid characters.", "err_team_empty": "Team name: empty field.",
		"err_team_length": "Team name: 13 characters maximum.", "err_team_chars": "Team name: invalid characters."
	},
	"es": {
		"manager": "Nombre del manager", "team": "Nombre del equipo", "confirm": "Confirmar",
		"err_mgr_empty": "Nombre del manager: campo vacío.", "err_mgr_length": "Nombre del manager: máximo 13 caracteres.",
		"err_mgr_chars": "Nombre del manager: caracteres no permitidos.", "err_team_empty": "Nombre del equipo: campo vacío.",
		"err_team_length": "Nombre del equipo: máximo 13 caracteres.", "err_team_chars": "Nombre del equipo: caracteres no permitidos."
	},
	"de": {
		"manager": "Manager-Name", "team": "Teamname", "confirm": "Bestätigen",
		"err_mgr_empty": "Manager-Name: leeres Feld.", "err_mgr_length": "Manager-Name: maximal 13 Zeichen.",
		"err_mgr_chars": "Manager-Name: ungültige Zeichen.", "err_team_empty": "Teamname: leeres Feld.",
		"err_team_length": "Teamname: maximal 13 Zeichen.", "err_team_chars": "Teamname: ungültige Zeichen."
	},
	"it": {
		"manager": "Nome del manager", "team": "Nome della squadra", "confirm": "Conferma",
		"err_mgr_empty": "Nome del manager: campo vuoto.", "err_mgr_length": "Nome del manager: massimo 13 caratteri.",
		"err_mgr_chars": "Nome del manager: caratteri non consentiti.", "err_team_empty": "Nome della squadra: campo vuoto.",
		"err_team_length": "Nome della squadra: massimo 13 caratteri.", "err_team_chars": "Nome della squadra: caratteri non consentiti."
	},
	"pt": {
		"manager": "Nome do manager", "team": "Nome da equipa", "confirm": "Confirmar",
		"err_mgr_empty": "Nome do manager: campo vazio.", "err_mgr_length": "Nome do manager: máximo 13 caracteres.",
		"err_mgr_chars": "Nome do manager: caracteres não permitidos.", "err_team_empty": "Nome da equipa: campo vazio.",
		"err_team_length": "Nome da equipa: máximo 13 caracteres.", "err_team_chars": "Nome da equipa: caracteres não permitidos."
	}
}

func _ready():
	Taskbar.visible = false
	lineedit_manager.max_length = MAX_NAME_LENGTH; lineedit_team.max_length = MAX_NAME_LENGTH
	txt_error_manager.visible = false; txt_error_team.visible = false
	_apply_translations()
	Firebase.firestore_success.connect(_on_firestore_success)
	Firebase.firestore_failed.connect(_on_firestore_failed)

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_manager_label.text = t["manager"]; txt_team_label.text = t["team"]; txt_confirm.text = t["confirm"]

func _is_valid_name(name: String) -> bool:
	for c in name:
		if not (c in ALLOWED_CHARS): return false
	return true

func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	if _sprite_hit(btn_confirm, event.position): _try_confirm()

func _try_confirm():
	var t = TRANSLATIONS[GameState.language]
	var manager_name = lineedit_manager.text.strip_edges()
	var team_name    = lineedit_team.text.strip_edges()
	var valid = true
	txt_error_manager.visible = false; txt_error_team.visible = false
	if manager_name == "":
		txt_error_manager.text = t["err_mgr_empty"]; txt_error_manager.visible = true; valid = false
	elif manager_name.length() > MAX_NAME_LENGTH:
		txt_error_manager.text = t["err_mgr_length"]; txt_error_manager.visible = true; valid = false
	elif not _is_valid_name(manager_name):
		txt_error_manager.text = t["err_mgr_chars"]; txt_error_manager.visible = true; valid = false
	if team_name == "":
		txt_error_team.text = t["err_team_empty"]; txt_error_team.visible = true; valid = false
	elif team_name.length() > MAX_NAME_LENGTH:
		txt_error_team.text = t["err_team_length"]; txt_error_team.visible = true; valid = false
	elif not _is_valid_name(team_name):
		txt_error_team.text = t["err_team_chars"]; txt_error_team.visible = true; valid = false
	if not valid: return
	Firebase.create_document("managers", Firebase.user_id, {
		"manager_name": manager_name, "team_name": team_name,
		"language": GameState.language, "sound_on": GameState.sound_on
	})

# ── PACK DE DÉPART ───────────────────────────────────────────────────────────
const CARD_SCENE      = "res://Scenes/card_player.tscn"
const STARTER_COLORS  = [
	"yellow","yellow","yellow","yellow","yellow","yellow","yellow","yellow",
	"orange","orange","orange","orange","orange","orange","orange","orange",
	"red","red","red","red",
	"magenta","magenta","magenta",
	"blue","blue",
	"white","white"
]
const ALL_POSITIONS = ["GB","DG","DD","DC","MG","MD","MDF","MC","MO","AG","AD","AC","ATT"]

var _cards_pending: int = 0
var _covered_positions: Array = []
var _generated_cards: Array = []

func _generate_starter_pack():
	_cards_pending     = 0
	_covered_positions = []
	_generated_cards   = []
	for color in STARTER_COLORS:
		_generate_card_with_color(color)
	_ensure_all_positions()
	_save_all_cards()

func _generate_card_with_color(color: String) -> Dictionary:
	var card_scene = load(CARD_SCENE)
	var card = card_scene.instantiate()
	match color:
		"yellow":  card.note = randi_range(60, 69)
		"orange":  card.note = randi_range(70, 79)
		"red":     card.note = randi_range(80, 89)
		"magenta": card.note = randi_range(90, 99)
		"blue":    card.note = randi_range(100, 129)
		"white":   card.note = randi_range(40, 70)
	card.color = color
	card.generate_age_height_weight()
	card.generate_nationality()
	card.generate_positions()
	card.generate_name()
	card.generate_specialties()
	card.generate_skills()
	card.selected_card_id = str(Time.get_unix_time_from_system()) + "_" + str(randi())
	var d = _card_to_dict(card)
	_generated_cards.append(d)
	if card.position1 not in _covered_positions:
		_covered_positions.append(card.position1)
	card.queue_free()
	return d

func _ensure_all_positions():
	for pos in ALL_POSITIONS:
		if pos not in _covered_positions:
			var d = _generate_card_with_color("yellow")
			d["position1"] = pos
			d["position2"] = ""

func _card_to_dict(card) -> Dictionary:
	return {
		"card_id": card.selected_card_id,
		"note": card.note, "color": card.color,
		"position1": card.position1, "position2": card.position2,
		"position2_unlocked": 0,
		"age": card.age, "height": card.height, "weight": card.weight,
		"nationality": card.nationality,
		"specialty1": card.specialty1, "specialty2": card.specialty2,
		"firstname": card.firstname, "lastname": card.lastname,
		"pin_color": "",
		"strength": card.strength, "speed": card.speed,
		"aggression": card.aggression, "positioning": card.positioning,
		"stamina": card.stamina, "creativity": card.creativity,
		"concentration": card.concentration, "motivation": card.motivation,
		"anticipation": card.anticipation, "communication": card.communication
	}

func _save_all_cards():
	_cards_pending = _generated_cards.size()
	Firebase.firestore_success.connect(_on_card_saved)
	Firebase.firestore_failed.connect(_on_card_save_failed)
	for d in _generated_cards:
		Firebase.update_document(
			"managers/" + Firebase.user_id + "/cards",
			d["card_id"], d)

func _on_card_saved(_data: Dictionary):
	_cards_pending -= 1
	if _cards_pending <= 0:
		if Firebase.firestore_success.is_connected(_on_card_saved):
			Firebase.firestore_success.disconnect(_on_card_saved)
		if Firebase.firestore_failed.is_connected(_on_card_save_failed):
			Firebase.firestore_failed.disconnect(_on_card_save_failed)
		get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _on_card_save_failed(_error: String):
	_cards_pending -= 1
	if _cards_pending <= 0:
		if Firebase.firestore_success.is_connected(_on_card_saved):
			Firebase.firestore_success.disconnect(_on_card_saved)
		if Firebase.firestore_failed.is_connected(_on_card_save_failed):
			Firebase.firestore_failed.disconnect(_on_card_save_failed)
		get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _on_firestore_success(_data: Dictionary):
	# Profil créé → générer le pack de départ
	if Firebase.firestore_success.is_connected(_on_firestore_success):
		Firebase.firestore_success.disconnect(_on_firestore_success)
	if Firebase.firestore_failed.is_connected(_on_firestore_failed):
		Firebase.firestore_failed.disconnect(_on_firestore_failed)
	_generate_starter_pack()

func _on_firestore_failed(error: String):
	print("Erreur Firestore : " + error)
	get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
