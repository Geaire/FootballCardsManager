extends Node2D

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var img_flag_fr = $CNT_Languages/IMG_FlagFr
@onready var img_flag_en = $CNT_Languages/IMG_FlagEn
@onready var img_flag_de = $CNT_Languages/IMG_FlagDe
@onready var img_flag_it = $CNT_Languages/IMG_FlagIt
@onready var img_flag_es = $CNT_Languages/IMG_FlagEs
@onready var img_flag_pt = $CNT_Languages/IMG_FlagPt
@onready var lbl_content = $PNL_NotifPopup/CNT_PopupContent/LBL_Content
@onready var btn_accept  = $PNL_NotifPopup/CNT_PopupContent/BTN_Accept
@onready var btn_refuse  = $PNL_NotifPopup/CNT_PopupContent/BTN_Refuse

# ── TRADUCTIONS ────────────────────────────────────────────────────────────────
const TRANSLATIONS = {
	"fr": {
		"content": "Autoriser Football Cards Manager à vous envoyer des notifications ?",
		"accept":  "Autoriser",
		"refuse":  "Ne pas autoriser"
	},
	"en": {
		"content": "Allow Football Cards Manager to send you notifications?",
		"accept":  "Allow",
		"refuse":  "Don't allow"
	},
	"es": {
		"content": "¿Permitir que Football Cards Manager te envíe notificaciones?",
		"accept":  "Permitir",
		"refuse":  "No permitir"
	},
	"de": {
		"content": "Möchten Sie Football Cards Manager erlauben, Ihnen Benachrichtigungen zu senden?",
		"accept":  "Erlauben",
		"refuse":  "Nicht erlauben"
	},
	"it": {
		"content": "Consentire a Football Cards Manager di inviarti notifiche?",
		"accept":  "Consenti",
		"refuse":  "Non consentire"
	},
	"pt": {
		"content": "Permitir que Football Cards Manager envie notificações para você?",
		"accept":  "Permitir",
		"refuse":  "Não permitir"
	}
}

const SCENE_LOGIN = "res://Scenes/login.tscn"

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible = false
	# Détection langue système, fallback français
	var locale = OS.get_locale_language()
	GameState.language = locale if locale in TRANSLATIONS else "fr"
	_apply_translations()
	# Connexion signaux Button natifs
	btn_accept.pressed.connect(_on_btn_accept_pressed)
	btn_refuse.pressed.connect(_on_btn_refuse_pressed)
	# Connexion signaux drapeaux
	img_flag_fr.gui_input.connect(func(e): _on_flag_input(e, "fr", img_flag_fr))
	img_flag_en.gui_input.connect(func(e): _on_flag_input(e, "en", img_flag_en))
	img_flag_de.gui_input.connect(func(e): _on_flag_input(e, "de", img_flag_de))
	img_flag_it.gui_input.connect(func(e): _on_flag_input(e, "it", img_flag_it))
	img_flag_es.gui_input.connect(func(e): _on_flag_input(e, "es", img_flag_es))
	img_flag_pt.gui_input.connect(func(e): _on_flag_input(e, "pt", img_flag_pt))

# ── TRADUCTIONS ────────────────────────────────────────────────────────────────
func _apply_translations():
	var t       = TRANSLATIONS[GameState.language]
	lbl_content.text = t["content"]
	btn_accept.text  = t["accept"]
	btn_refuse.text  = t["refuse"]

# ── DRAPEAUX ──────────────────────────────────────────────────────────────────
func _on_flag_input(event: InputEvent, lang: String, flag: TextureRect):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		GameState.language = lang
		_shake_flag(flag)
		_apply_translations()

func _shake_flag(flag: TextureRect):
	var tween  = create_tween()
	var orig_x = flag.position.x
	tween.tween_property(flag, "position:x", orig_x + 8,  0.05)
	tween.tween_property(flag, "position:x", orig_x - 8,  0.05)
	tween.tween_property(flag, "position:x", orig_x + 5,  0.04)
	tween.tween_property(flag, "position:x", orig_x - 5,  0.04)
	tween.tween_property(flag, "position:x", orig_x,      0.03)

# ── BOUTONS ───────────────────────────────────────────────────────────────────
func _on_btn_accept_pressed():
	GameState.notifications_enabled = true
	get_tree().change_scene_to_file(SCENE_LOGIN)

func _on_btn_refuse_pressed():
	GameState.notifications_enabled = false
	get_tree().change_scene_to_file(SCENE_LOGIN)
