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

const ALLOWED_CHARS   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZaaieeeiouucnouiuAAEEEEIIOUUUCN 0123456789-'"


const TRANSLATIONS = {

	"fr": {

		"manager": "Nom du manager", "team": "Nom de l'equipe", "confirm": "Confirmer",

		"err_mgr_empty": "Nom du manager : champ vide.",

		"err_mgr_length": "Nom du manager : 13 caracteres maximum.",

		"err_mgr_chars": "Nom du manager : caracteres non autorises.",

		"err_team_empty": "Nom d'equipe : champ vide.",

		"err_team_length": "Nom d'equipe : 13 caracteres maximum.",

		"err_team_chars": "Nom d'equipe : caracteres non autorises."

	},

	"en": {

		"manager": "Manager name", "team": "Team name", "confirm": "Confirm",

		"err_mgr_empty": "Manager name: empty field.",

		"err_mgr_length": "Manager name: 13 characters maximum.",

		"err_mgr_chars": "Manager name: invalid characters.",

		"err_team_empty": "Team name: empty field.",

		"err_team_length": "Team name: 13 characters maximum.",

		"err_team_chars": "Team name: invalid characters."

	},

	"es": {

		"manager": "Nombre del manager", "team": "Nombre del equipo", "confirm": "Confirmar",

		"err_mgr_empty": "Nombre del manager: campo vacio.",

		"err_mgr_length": "Nombre del manager: maximo 13 caracteres.",

		"err_mgr_chars": "Nombre del manager: caracteres no permitidos.",

		"err_team_empty": "Nombre del equipo: campo vacio.",

		"err_team_length": "Nombre del equipo: maximo 13 caracteres.",

		"err_team_chars": "Nombre del equipo: caracteres no permitidos."

	},

	"de": {

		"manager": "Manager-Name", "team": "Teamname", "confirm": "Bestatigen",

		"err_mgr_empty": "Manager-Name: leeres Feld.",

		"err_mgr_length": "Manager-Name: maximal 13 Zeichen.",

		"err_mgr_chars": "Manager-Name: ungultige Zeichen.",

		"err_team_empty": "Teamname: leeres Feld.",

		"err_team_length": "Teamname: maximal 13 Zeichen.",

		"err_team_chars": "Teamname: ungultige Zeichen."

	},

	"it": {

		"manager": "Nome del manager", "team": "Nome della squadra", "confirm": "Conferma",

		"err_mgr_empty": "Nome del manager: campo vuoto.",

		"err_mgr_length": "Nome del manager: massimo 13 caratteri.",

		"err_mgr_chars": "Nome del manager: caratteri non consentiti.",

		"err_team_empty": "Nome della squadra: campo vuoto.",

		"err_team_length": "Nome della squadra: massimo 13 caratteri.",

		"err_team_chars": "Nome della squadra: caratteri non consentiti."

	},

	"pt": {

		"manager": "Nome do manager", "team": "Nome da equipa", "confirm": "Confirmar",

		"err_mgr_empty": "Nome do manager: campo vazio.",

		"err_mgr_length": "Nome do manager: maximo 13 caracteres.",

		"err_mgr_chars": "Nome do manager: caracteres nao permitidos.",

		"err_team_empty": "Nome da equipa: campo vazio.",

		"err_team_length": "Nome da equipa: maximo 13 caracteres.",

		"err_team_chars": "Nome da equipa: caracteres nao permitidos."

	}

}


func _ready():

	lineedit_manager.max_length = MAX_NAME_LENGTH

	lineedit_team.max_length    = MAX_NAME_LENGTH

	txt_error_manager.visible   = false

	txt_error_team.visible      = false

	_apply_translations()

	Firebase.firestore_success.connect(_on_firestore_success)

	Firebase.firestore_failed.connect(_on_firestore_failed)


func _apply_translations():

	var t = TRANSLATIONS[GameState.language]

	txt_manager_label.text = t["manager"]

	txt_team_label.text    = t["team"]

	txt_confirm.text       = t["confirm"]


func _is_valid_name(name: String) -> bool:

	for c in name:

		if not (c in ALLOWED_CHARS): return false

	return true


func _input(event):

	if not (event is InputEventMouseButton): return

	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return

	if _sprite_hit(btn_confirm, event.position): _try_confirm()


func _try_confirm():

	var t            = TRANSLATIONS[GameState.language]

	var manager_name = lineedit_manager.text.strip_edges()

	var team_name    = lineedit_team.text.strip_edges()

	var valid        = true

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


func _on_firestore_success(_data: Dictionary):

	get_tree().change_scene_to_file(SCENE_MAIN_MENU)


func _on_firestore_failed(error: String):

	print("Erreur Firestore : " + error)

	get_tree().change_scene_to_file(SCENE_MAIN_MENU)


func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:

	if not sprite.visible: return false

	return sprite.get_rect().has_point(sprite.to_local(pos))
