extends Node2D

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var lbl_manager           = $LBL_Manager
@onready var inp_manager           = $INP_Manager
@onready var lbl_incorrect_manager = $LBL_IncorrectManager
@onready var lbl_team              = $LBL_Team
@onready var inp_team              = $INP_Team
@onready var lbl_incorrect_team    = $LBL_IncorrectTeam
@onready var btn_confirm           = $BTN_Confirm

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const SCENE_MAIN_MENU   = "res://Scenes/main_menu.tscn"
const CARD_SCENE        = "res://Scenes/card_player.tscn"
const MAX_NAME_LENGTH   = 13
const ALLOWED_CHARS     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-'"

const STARTER_PACK = {
	"yellow":  60,
	"orange":  60,
	"red":     60,
	"magenta": 60,
	"blue":    10,
	"white":   10,
}

var _cards_pending:   int   = 0
var _generated_cards: Array = []

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible               = false
	inp_manager.max_length        = MAX_NAME_LENGTH
	inp_team.max_length           = MAX_NAME_LENGTH
	lbl_incorrect_manager.visible = false
	lbl_incorrect_team.visible    = false
	lbl_manager.text              = "Manager Name"
	lbl_team.text                 = "Team Name"
	btn_confirm.text              = "Confirm"
	btn_confirm.gui_input.connect(_on_btn_confirm_input)

# ── VALIDATION ────────────────────────────────────────────────────────────────
func _is_valid_name(value: String) -> bool:
	for c in value:
		if not (c in ALLOWED_CHARS): return false
	return true

func _on_btn_confirm_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_try_confirm()

func _try_confirm():
	var manager_name = inp_manager.text.strip_edges()
	var team_name    = inp_team.text.strip_edges()
	var valid        = true
	lbl_incorrect_manager.visible = false
	lbl_incorrect_team.visible    = false

	if manager_name == "":
		lbl_incorrect_manager.text    = "Incorrect Manager Name: empty field."
		lbl_incorrect_manager.visible = true; valid = false
	elif manager_name.length() > MAX_NAME_LENGTH:
		lbl_incorrect_manager.text    = "Incorrect Manager Name: 13 characters maximum."
		lbl_incorrect_manager.visible = true; valid = false
	elif not _is_valid_name(manager_name):
		lbl_incorrect_manager.text    = "Incorrect Manager Name: invalid characters."
		lbl_incorrect_manager.visible = true; valid = false

	if team_name == "":
		lbl_incorrect_team.text    = "Incorrect Team Name: empty field."
		lbl_incorrect_team.visible = true; valid = false
	elif team_name.length() > MAX_NAME_LENGTH:
		lbl_incorrect_team.text    = "Incorrect Team Name: 13 characters maximum."
		lbl_incorrect_team.visible = true; valid = false
	elif not _is_valid_name(team_name):
		lbl_incorrect_team.text    = "Incorrect Team Name: invalid characters."
		lbl_incorrect_team.visible = true; valid = false

	if not valid: return

	GameState.manager_name = manager_name
	GameState.team_name    = team_name

	# ── Générer les cartes IMMÉDIATEMENT dans le cache local ──────────────────
	# Indépendant de Firestore — le manager a toujours ses cartes même si Firebase
	# est lent ou en erreur.
	_generate_starter_pack()

	# ── Sauvegarder le profil en Firestore (best-effort) ─────────────────────
	Firebase.firestore_success.connect(_on_profile_saved)
	Firebase.firestore_failed.connect(_on_profile_failed)
	Firebase.create_document("managers", Firebase.user_id, {
		"manager_name": manager_name,
		"team_name":    team_name,
		"language":     GameState.language,
		"sound_on":     GameState.sound_on
	})

# ── PROFIL FIRESTORE ──────────────────────────────────────────────────────────
func _on_profile_saved(_data: Dictionary):
	_disconnect_profile_signals()
	_save_all_cards()

func _on_profile_failed(error: String):
	print("Profile Firestore failed (non-blocking): " + error)
	_disconnect_profile_signals()
	_save_all_cards()

func _disconnect_profile_signals():
	if Firebase.firestore_success.is_connected(_on_profile_saved):
		Firebase.firestore_success.disconnect(_on_profile_saved)
	if Firebase.firestore_failed.is_connected(_on_profile_failed):
		Firebase.firestore_failed.disconnect(_on_profile_failed)

# ── GÉNÉRATION DU STARTER PACK ────────────────────────────────────────────────
func _generate_starter_pack():
	_generated_cards = []
	for color in STARTER_PACK:
		for i in range(STARTER_PACK[color]):
			var card = _generate_card(color)
			_generated_cards.append(card)
			SquadLoader.add_card(card)
	GameState.cards_loaded = true

func _generate_card(color: String) -> Dictionary:
	var card_scene = load(CARD_SCENE)
	var card       = card_scene.instantiate()
	card.color     = color
	match color:
		"yellow":  card.note = randi_range(60, 69)
		"orange":  card.note = randi_range(70, 79)
		"red":     card.note = randi_range(80, 89)
		"magenta": card.note = randi_range(90, 99)
		"blue":    card.note = randi_range(100, 129)
		"white":   card.note = 40  # Toujours 40 — jamais randomisé
	card.generate_age_height_weight()
	card.generate_nationality()
	card.generate_positions()
	card.generate_name()
	card.generate_specialties()
	card.generate_skills()
	card.selected_card_id = str(Time.get_unix_time_from_system()) \
		+ "_" + str(randi()) + "_" + str(_generated_cards.size())
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
		"communication":      card.communication,
		"training_tier":      0,
		"training_matches":   0,
	}
	card.queue_free()
	return d

# ── SAUVEGARDE FIRESTORE ──────────────────────────────────────────────────────
func _save_all_cards():
	_cards_pending = _generated_cards.size()
	if _cards_pending == 0:
		get_tree().change_scene_to_file(SCENE_MAIN_MENU)
		return
	Firebase.firestore_success.connect(_on_card_saved)
	Firebase.firestore_failed.connect(_on_card_save_failed)
	for d in _generated_cards:
		Firebase.update_document(
			"managers/" + Firebase.user_id + "/cards",
			d["card_id"], d
		)

func _on_card_saved(_data: Dictionary):
	_cards_pending -= 1
	if _cards_pending <= 0:
		_disconnect_card_signals()
		get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _on_card_save_failed(_error: String):
	_cards_pending -= 1
	if _cards_pending <= 0:
		_disconnect_card_signals()
		get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _disconnect_card_signals():
	if Firebase.firestore_success.is_connected(_on_card_saved):
		Firebase.firestore_success.disconnect(_on_card_saved)
	if Firebase.firestore_failed.is_connected(_on_card_save_failed):
		Firebase.firestore_failed.disconnect(_on_card_save_failed)
