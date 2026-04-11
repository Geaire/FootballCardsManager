extends Node2D

# --- NOEUDS ---
@onready var txt_content = $TXT_Content
@onready var btn_accept = $TXT_Accept
@onready var btn_refuse = $TXT_Refuse

# --- TRADUCTIONS ---
const TRANSLATIONS = {
	"fr": {
		"content": "Autoriser Football Cards Manager à vous envoyer des notifications ?",
		"accept": "Autoriser",
		"refuse": "Ne pas autoriser"
	},
	"en": {
		"content": "Allow Football Cards Manager to send you notifications?",
		"accept": "Allow",
		"refuse": "Don't allow"
	},
	"es": {
		"content": "¿Permitir que Football Cards Manager te envíe notificaciones?",
		"accept": "Permitir",
		"refuse": "No permitir"
	},
	"de": {
		"content": "Erlauben Sie Football Cards Manager, Ihnen Benachrichtigungen zu senden?",
		"accept": "Erlauben",
		"refuse": "Nicht erlauben"
	},
	"it": {
		"content": "Consentire a Football Cards Manager di inviarti notifiche?",
		"accept": "Consenti",
		"refuse": "Non consentire"
	},
	"pt": {
		"content": "Permitir que Football Cards Manager envie notificações para você?",
		"accept": "Permitir",
		"refuse": "Não permitir"
	}
}

const SCENE_LOGIN = "res://Scenes/login.tscn"

# --- READY ---
func _ready():
	_apply_translations()

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_content.text = t["content"]
	btn_accept.text = t["accept"]
	btn_refuse.text = t["refuse"]

# --- INPUT ---
func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var pos = event.position

	if _label_hit(btn_accept, pos):
		GameState.notifications_enabled = true
		get_tree().change_scene_to_file(SCENE_LOGIN)
		return

	if _label_hit(btn_refuse, pos):
		GameState.notifications_enabled = false
		get_tree().change_scene_to_file(SCENE_LOGIN)
		return

# --- UTILITAIRES ---
func _label_hit(label: Label, pos: Vector2) -> bool:
	if not label.visible:
		return false
	return label.get_global_rect().has_point(pos)
