extends Node2D

# --- NOEUDS ---
@onready var btn_sound_on = $BTN_SoundOn
@onready var btn_sound_off = $BTN_SoundOff
@onready var ovl_language = $OVL_Language
@onready var card_deco1 = $Card_Player1
@onready var card_deco2 = $Card_Player2
@onready var txt_version = $TXT_Version
@onready var btn_play = $BTN_Play
@onready var txt_play = $TXT_Play
@onready var lang_fr = $Lang_FR
@onready var lang_en = $Lang_EN
@onready var lang_de = $Lang_DE
@onready var lang_it = $Lang_IT
@onready var lang_es = $Lang_ES
@onready var lang_pt = $Lang_PT
@onready var txt_slogan1 = $TXT_Slogan1
@onready var txt_slogan2 = $TXT_Slogan2
@onready var txt_slogan3 = $TXT_Slogan3
@onready var txt_language = $TXT_Language

# --- TRADUCTIONS ---
const TRANSLATIONS = {
	"fr": {
		"slogan1": "Construis. Pense. Domine.",
		"slogan2": "Pas de hasard, le meilleur gagne toujours.",
		"slogan3": "Oublie les tactiques. Maîtrise les bonus.",
		"language": "Langue",
		"play": "Jouer"
	},
	"en": {
		"slogan1": "Build. Think. Dominate.",
		"slogan2": "No luck, the best always wins.",
		"slogan3": "Forget tactics. Master the bonuses.",
		"language": "Language",
		"play": "Play"
	},
	"es": {
		"slogan1": "Construye. Piensa. Domina.",
		"slogan2": "Sin suerte, el mejor siempre gana.",
		"slogan3": "Olvida las tácticas. Domina los bonos.",
		"language": "Idioma",
		"play": "Jugar"
	},
	"de": {
		"slogan1": "Baue. Denke. Dominiere.",
		"slogan2": "Kein Zufall, der Beste gewinnt immer.",
		"slogan3": "Vergiss Taktiken. Meistere die Boni.",
		"language": "Sprache",
		"play": "Spielen"
	},
	"it": {
		"slogan1": "Costruisci. Pensa. Domina.",
		"slogan2": "Nessuna fortuna, il migliore vince sempre.",
		"slogan3": "Dimentica le tattiche. Padroneggia i bonus.",
		"language": "Lingua",
		"play": "Giocare"
	},
	"pt": {
		"slogan1": "Constrói. Pensa. Domina.",
		"slogan2": "Sem sorte, o melhor sempre vence.",
		"slogan3": "Esqueça as táticas. Domine os bônus.",
		"language": "Língua",
		"play": "Jogar"
	}
}

# --- CONSTANTES ---
const SFX_CLICK = "res://Audio/sfx_click.wav"
const SCENE_COMPETITION = "res://Scenes/competition.tscn"

# --- READY ---
func _ready():
	txt_version.text = "V 0.1"
	btn_sound_on.visible = GameState.sound_on
	btn_sound_off.visible = not GameState.sound_on
	ovl_language.visible = false
	_set_lang_flags_visible(false)
	card_deco1.clickable = true
	card_deco2.clickable = true
	card_deco1.generate()
	card_deco1.display()
	card_deco2.generate()
	card_deco2.display()
	_apply_translations()

func _set_lang_flags_visible(value: bool):
	lang_fr.visible = value
	lang_en.visible = value
	lang_de.visible = value
	lang_it.visible = value
	lang_es.visible = value
	lang_pt.visible = value

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_slogan1.text = t["slogan1"]
	txt_slogan2.text = t["slogan2"]
	txt_slogan3.text = t["slogan3"]
	txt_language.text = t["language"]
	txt_play.text = t["play"]

# --- INPUT ---
func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	var pos = event.position

	# PLAY
	if _sprite_hit(btn_play, pos):
		play_click_sound()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(SCENE_COMPETITION)
		return

	# SON ON -> OFF
	if _sprite_hit(btn_sound_on, pos) and btn_sound_on.visible:
		GameState.sound_on = false
		btn_sound_on.visible = false
		btn_sound_off.visible = true
		return

	# SON OFF -> ON
	if _sprite_hit(btn_sound_off, pos) and btn_sound_off.visible:
		GameState.sound_on = true
		btn_sound_on.visible = true
		btn_sound_off.visible = false
		play_click_sound()
		return

	# LANGUE - ouvrir overlay
	if _label_hit(txt_language, pos) and not ovl_language.visible:
		play_click_sound()
		ovl_language.visible = true
		_set_lang_flags_visible(true)
		return

	# DRAPEAUX
	if ovl_language.visible:
		if _sprite_hit(lang_fr, pos):
			_select_language("fr")
		elif _sprite_hit(lang_en, pos):
			_select_language("en")
		elif _sprite_hit(lang_de, pos):
			_select_language("de")
		elif _sprite_hit(lang_it, pos):
			_select_language("it")
		elif _sprite_hit(lang_es, pos):
			_select_language("es")
		elif _sprite_hit(lang_pt, pos):
			_select_language("pt")
		else:
			ovl_language.visible = false
			_set_lang_flags_visible(false)
		return

func _select_language(lang: String):
	GameState.language = lang
	ovl_language.visible = false
	_set_lang_flags_visible(false)
	_apply_translations()
	play_click_sound()

# --- UTILITAIRES ---
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if not label.visible:
		return false
	return label.get_global_rect().has_point(pos)

func play_click_sound():
	if not GameState.sound_on:
		return
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(SFX_CLICK)
	player.play()
	await player.finished
	player.queue_free()
