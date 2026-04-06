extends Node2D

# --- NOEUDS ---
@onready var btn_sound_on = $BTN_SoundOn
@onready var btn_sound_off = $BTN_SoundOff
@onready var ovl_language = $OVL_Language
@onready var card_Player1 = $Card_Player1
@onready var card_Player2 = $Card_Player2
@onready var txt_version = $TXT_Version
@onready var btn_play = $BTN_Play
@onready var lang_fr = $Lang_FR
@onready var lang_en = $Lang_EN
@onready var lang_de = $Lang_DE
@onready var lang_it = $Lang_IT
@onready var lang_es = $Lang_ES
@onready var lang_pt = $Lang_PT

# --- CONSTANTES ---
const SFX_CLICK = "res://Audio/sfx_click.wav"

# --- READY ---
func _ready():
	txt_version.text = "V 0.1"
	btn_sound_on.visible = GameState.sound_on
	btn_sound_off.visible = not GameState.sound_on
	ovl_language.visible = false
	_set_lang_flags_visible(false)
	card_Player1.clickable = true
	card_Player2.clickable = true
	card_Player1.generate()
	card_Player1.display()
	card_Player2.generate()
	card_Player2.display()

func _set_lang_flags_visible(value: bool):
	lang_fr.visible = value
	lang_en.visible = value
	lang_de.visible = value
	lang_it.visible = value
	lang_es.visible = value
	lang_pt.visible = value

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
		get_tree().change_scene_to_file("res://Scenes/competition.tscn")
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
	if _label_hit($TXT_Language, pos) and not ovl_language.visible:
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
			# Clic ailleurs = fermer overlay
			ovl_language.visible = false
			_set_lang_flags_visible(false)
		return

func _select_language(lang: String):
	GameState.language = lang
	ovl_language.visible = false
	_set_lang_flags_visible(false)
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
