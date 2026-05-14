extends Node2D

@onready var lbl_manager           = $LBL_Manager
@onready var inp_manager           = $INP_Manager
@onready var lbl_incorrect_manager = $LBL_IncorrectManager
@onready var lbl_team              = $LBL_Team
@onready var inp_team              = $INP_Team
@onready var lbl_incorrect_team    = $LBL_IncorrectTeam
@onready var btn_confirm           = $BTN_Confirm
@onready var lbl_loading           = $LBL_Loading   # Label de progression — à créer dans la scène
@onready var prg_loading           = $PRG_Loading   # ProgressBar — à créer dans la scène

const MAX_NAME_LENGTH = 13
const SCENE_SCHEDULE  = "res://Scenes/schedule.tscn"
const ALLOWED_CHARS   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-'"

const TRANSLATIONS = {
	"fr": {
		"manager": "Nom du manager", "team": "Nom de l'équipe", "confirm": "Confirmer",
		"loading": "Création du profil...",
		"err_mgr_empty":  "Nom du manager : champ vide.",
		"err_mgr_length": "Nom du manager : 13 caractères maximum.",
		"err_mgr_chars":  "Nom du manager : caractères non autorisés.",
		"err_team_empty":  "Nom d'équipe : champ vide.",
		"err_team_length": "Nom d'équipe : 13 caractères maximum.",
		"err_team_chars":  "Nom d'équipe : caractères non autorisés."
	},
	"en": {
		"manager": "Manager name", "team": "Team name", "confirm": "Confirm",
		"loading": "Creating profile...",
		"err_mgr_empty":  "Manager name: empty field.",
		"err_mgr_length": "Manager name: 13 characters maximum.",
		"err_mgr_chars":  "Manager name: invalid characters.",
		"err_team_empty":  "Team name: empty field.",
		"err_team_length": "Team name: 13 characters maximum.",
		"err_team_chars":  "Team name: invalid characters."
	},
	"es": {
		"manager": "Nombre del manager", "team": "Nombre del equipo", "confirm": "Confirmar",
		"loading": "Creando perfil...",
		"err_mgr_empty":  "Nombre del manager: campo vacío.",
		"err_mgr_length": "Nombre del manager: máximo 13 caracteres.",
		"err_mgr_chars":  "Nombre del manager: caracteres no permitidos.",
		"err_team_empty":  "Nombre del equipo: campo vacío.",
		"err_team_length": "Nombre del equipo: máximo 13 caracteres.",
		"err_team_chars":  "Nombre del equipo: caracteres no permitidos."
	},
	"de": {
		"manager": "Manager-Name", "team": "Teamname", "confirm": "Bestätigen",
		"loading": "Profil wird erstellt...",
		"err_mgr_empty":  "Manager-Name: leeres Feld.",
		"err_mgr_length": "Manager-Name: maximal 13 Zeichen.",
		"err_mgr_chars":  "Manager-Name: ungültige Zeichen.",
		"err_team_empty":  "Teamname: leeres Feld.",
		"err_team_length": "Teamname: maximal 13 Zeichen.",
		"err_team_chars":  "Teamname: ungültige Zeichen."
	},
	"it": {
		"manager": "Nome del manager", "team": "Nome della squadra", "confirm": "Conferma",
		"loading": "Creazione del profilo...",
		"err_mgr_empty":  "Nome del manager: campo vuoto.",
		"err_mgr_length": "Nome del manager: massimo 13 caratteri.",
		"err_mgr_chars":  "Nome del manager: caratteri non consentiti.",
		"err_team_empty":  "Nome della squadra: campo vuoto.",
		"err_team_length": "Nome della squadra: massimo 13 caratteri.",
		"err_team_chars":  "Nome della squadra: caratteri non consentiti."
	},
	"pt": {
		"manager": "Nome do manager", "team": "Nome da equipa", "confirm": "Confirmar",
		"loading": "A criar o perfil...",
		"err_mgr_empty":  "Nome do manager: campo vazio.",
		"err_mgr_length": "Nome do manager: máximo 13 caracteres.",
		"err_mgr_chars":  "Nome do manager: caracteres não permitidos.",
		"err_team_empty":  "Nome da equipa: campo vazio.",
		"err_team_length": "Nome da equipa: máximo 13 caracteres.",
		"err_team_chars":  "Nome da equipa: caracteres não permitidos."
	}
}

const CARD_SCENE = "res://Scenes/card_player.tscn"
const TEST_PACK = {
	"yellow":  60,
	"orange":  60,
	"red":     60,
	"magenta": 60,
	"white":   10,
	"blue":    10,
}

var _generated_cards:  Array = []
var _save_index:       int   = 0
var _total_cards:      int   = 0

func _ready():
	Taskbar.visible = false
	inp_manager.max_length          = MAX_NAME_LENGTH
	inp_team.max_length             = MAX_NAME_LENGTH
	inp_manager.placeholder_text    = ""
	inp_team.placeholder_text       = ""
	lbl_incorrect_manager.visible   = false
	lbl_incorrect_team.visible      = false
	lbl_loading.visible             = false
	prg_loading.visible             = false
	_apply_translations()
	btn_confirm.gui_input.connect(_on_btn_confirm_input)

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	lbl_manager.text = t["manager"]
	lbl_team.text    = t["team"]
	btn_confirm.text = t["confirm"]

func _is_valid_name(input: String) -> bool:
	for c in input:
		if not (c in ALLOWED_CHARS): return false
	return true

func _on_btn_confirm_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_try_confirm()

func _try_confirm():
	var t            = TRANSLATIONS[GameState.language]
	var manager_name = inp_manager.text.strip_edges()
	var team_name    = inp_team.text.strip_edges()
	var valid        = true
	lbl_incorrect_manager.visible = false
	lbl_incorrect_team.visible    = false

	if manager_name == "":
		lbl_incorrect_manager.text    = t["err_mgr_empty"]
		lbl_incorrect_manager.visible = true; valid = false
	elif manager_name.length() > MAX_NAME_LENGTH:
		lbl_incorrect_manager.text    = t["err_mgr_length"]
		lbl_incorrect_manager.visible = true; valid = false
	elif not _is_valid_name(manager_name):
		lbl_incorrect_manager.text    = t["err_mgr_chars"]
		lbl_incorrect_manager.visible = true; valid = false

	if team_name == "":
		lbl_incorrect_team.text    = t["err_team_empty"]
		lbl_incorrect_team.visible = true; valid = false
	elif team_name.length() > MAX_NAME_LENGTH:
		lbl_incorrect_team.text    = t["err_team_length"]
		lbl_incorrect_team.visible = true; valid = false
	elif not _is_valid_name(team_name):
		lbl_incorrect_team.text    = t["err_team_chars"]
		lbl_incorrect_team.visible = true; valid = false

	if not valid: return

	GameState.manager_name = manager_name
	GameState.team_name    = team_name

	# Griser le bouton visuellement (Label, pas Button → pas de .disabled)
	btn_confirm.modulate = Color(0.5, 0.5, 0.5, 0.7)
	btn_confirm.gui_input.disconnect(_on_btn_confirm_input)
	lbl_loading.text     = TRANSLATIONS[GameState.language]["loading"]
	lbl_loading.visible  = true
	prg_loading.value    = 0
	prg_loading.visible  = true

	Firebase.firestore_success.connect(_on_profile_created)
	Firebase.firestore_failed.connect(_on_profile_failed)
	Firebase.create_document("managers", Firebase.user_id, {
		"manager_name": manager_name,
		"team_name":    team_name,
		"language":     GameState.language,
		"sound_on":     GameState.sound_on
	})

func _on_profile_created(_data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_profile_created):
		Firebase.firestore_success.disconnect(_on_profile_created)
	if Firebase.firestore_failed.is_connected(_on_profile_failed):
		Firebase.firestore_failed.disconnect(_on_profile_failed)
	_generate_and_save_cards()

func _on_profile_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_profile_created):
		Firebase.firestore_success.disconnect(_on_profile_created)
	if Firebase.firestore_failed.is_connected(_on_profile_failed):
		Firebase.firestore_failed.disconnect(_on_profile_failed)
	get_tree().change_scene_to_file(SCENE_SCHEDULE)

# ── GÉNÉRATION + SAUVEGARDE SÉQUENTIELLE ──────────────────────────────────────
func _generate_and_save_cards():
	_generated_cards = []
	for color in TEST_PACK:
		for i in range(TEST_PACK[color]):
			_generated_cards.append(_generate_card(color))
	_total_cards = _generated_cards.size()
	_save_index  = 0
	prg_loading.max_value = _total_cards
	_save_next_card()

func _generate_card(color: String) -> Dictionary:
	var card_scene = load(CARD_SCENE)
	var card       = card_scene.instantiate()
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
	var d = {
		"card_id":            card.selected_card_id,
		"note":               card.note,
		"color":              card.color,
		"position1":          card.position1,
		"position2":          card.position2,
		"position2_unlocked": 0,
		"age":                card.age,
		"height":             card.height,
		"weight":             card.weight,
		"nationality":        card.nationality,
		"specialty1":         card.specialty1,
		"specialty2":         card.specialty2,
		"firstname":          card.firstname,
		"lastname":           card.lastname,
		"ball_color":         "",
		"strength":           card.strength,
		"speed":              card.speed,
		"aggression":         card.aggression,
		"positioning":        card.positioning,
		"stamina":            card.stamina,
		"creativity":         card.creativity,
		"concentration":      card.concentration,
		"motivation":         card.motivation,
		"anticipation":       card.anticipation,
		"communication":      card.communication
	}
	card.queue_free()
	return d

func _save_next_card():
	if _save_index >= _total_cards:
		_on_all_saved()
		return
	var d = _generated_cards[_save_index]
	Firebase.firestore_success.connect(_on_one_card_saved)
	Firebase.firestore_failed.connect(_on_one_card_failed)
	Firebase.update_document("managers/" + Firebase.user_id + "/cards", d["card_id"], d)

func _on_one_card_saved(_data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_one_card_saved):
		Firebase.firestore_success.disconnect(_on_one_card_saved)
	if Firebase.firestore_failed.is_connected(_on_one_card_failed):
		Firebase.firestore_failed.disconnect(_on_one_card_failed)
	_save_index += 1
	prg_loading.value = _save_index
	lbl_loading.text  = str(_save_index) + " / " + str(_total_cards)
	await get_tree().process_frame
	_save_next_card()

func _on_one_card_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_one_card_saved):
		Firebase.firestore_success.disconnect(_on_one_card_saved)
	if Firebase.firestore_failed.is_connected(_on_one_card_failed):
		Firebase.firestore_failed.disconnect(_on_one_card_failed)
	_save_index += 1
	prg_loading.value = _save_index
	await get_tree().process_frame
	_save_next_card()

func _on_all_saved():
	get_tree().change_scene_to_file(SCENE_SCHEDULE)
