extends Node2D

@onready var txt_content  = $TXT_Content
@onready var btn_accept   = $TXT_Accept
@onready var btn_refuse   = $TXT_Refuse
@onready var txt_language = $TXT_Language
@onready var lang_fr      = $Lang_FR
@onready var lang_en      = $Lang_EN
@onready var lang_de      = $Lang_DE
@onready var lang_it      = $Lang_IT
@onready var lang_es      = $Lang_ES
@onready var lang_pt      = $Lang_PT

const TRANSLATIONS = {
	"fr": {
		"language": "Langue",
		"content":  "Autoriser Football Cards Manager à vous envoyer des notifications ?",
		"accept":   "Autoriser",
		"refuse":   "Ne pas autoriser"
	},
	"en": {
		"language": "Language",
		"content":  "Allow Football Cards Manager to send you notifications ?",
		"accept":   "Allow",
		"refuse":   "Don't allow"
	},
	"es": {
		"language": "Idioma",
		"content":  "¿Permitir que Football Cards Manager te envíe notificaciones?",
		"accept":   "Permitir",
		"refuse":   "No permitir"
	},
	"de": {
		"language": "Sprache",
		"content":  "Möchten Sie Football Cards Manager erlauben, Ihnen Benachrichtigungen zu senden?",
		"accept":   "Erlauben",
		"refuse":   "Nicht erlauben"
	},
	"it": {
		"language": "Lingua",
		"content":  "Consentire a Football Cards Manager di inviarti notifiche?",
		"accept":   "Consenti",
		"refuse":   "Non consentire"
	},
	"pt": {
		"language": "Idioma",
		"content":  "Permitir que Football Cards Manager envie notificações para você?",
		"accept":   "Permitir",
		"refuse":   "Não permitir"
	}
}

const SCENE_LOGIN = "res://Scenes/login.tscn"

func _ready():
	var locale = OS.get_locale_language()
	GameState.language = locale if locale in TRANSLATIONS else "fr"
	_apply_translations()

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_language.text = t["language"]
	txt_content.text  = t["content"]
	btn_accept.text   = t["accept"]
	btn_refuse.text   = t["refuse"]

func _shake_flag(flag: Sprite2D):
	var tween  = create_tween()
	var orig_x = flag.position.x
	tween.tween_property(flag, "position:x", orig_x + 8, 0.05)
	tween.tween_property(flag, "position:x", orig_x - 8, 0.05)
	tween.tween_property(flag, "position:x", orig_x + 5, 0.04)
	tween.tween_property(flag, "position:x", orig_x - 5, 0.04)
	tween.tween_property(flag, "position:x", orig_x,     0.03)

func _select_language(lang: String, flag: Sprite2D):
	GameState.language = lang
	_shake_flag(flag)
	_apply_translations()

func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if _sprite_hit(lang_fr, pos): _select_language("fr", lang_fr); return
	if _sprite_hit(lang_en, pos): _select_language("en", lang_en); return
	if _sprite_hit(lang_de, pos): _select_language("de", lang_de); return
	if _sprite_hit(lang_it, pos): _select_language("it", lang_it); return
	if _sprite_hit(lang_es, pos): _select_language("es", lang_es); return
	if _sprite_hit(lang_pt, pos): _select_language("pt", lang_pt); return
	if _label_hit(btn_accept, pos):
		GameState.notifications_enabled = true
		get_tree().change_scene_to_file(SCENE_LOGIN); return
	if _label_hit(btn_refuse, pos):
		GameState.notifications_enabled = false
		get_tree().change_scene_to_file(SCENE_LOGIN); return

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if not label.visible: return false
	return label.get_global_rect().has_point(pos)
