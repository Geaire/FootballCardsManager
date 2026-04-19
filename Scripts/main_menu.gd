extends Node2D

# ── NOEUDS ────────────────────────────────────────────────────────────────────
@onready var btn_sound_on  = $BTN_SoundOn
@onready var btn_sound_off = $BTN_SoundOff
@onready var card_deco1    = $Card_Player1
@onready var card_deco2    = $Card_Player2
@onready var txt_version   = $TXT_Version
@onready var btn_play      = $BTN_Play
@onready var txt_play      = $TXT_Play
@onready var txt_slogan1   = $TXT_Slogan1
@onready var txt_slogan2   = $TXT_Slogan2
@onready var txt_slogan3   = $TXT_Slogan3

# ── TRADUCTIONS ───────────────────────────────────────────────────────────────
const TRANSLATIONS = {
	"fr": {"slogan1": "Construis. Pense. Domine.", "slogan2": "Pas de hasard, le meilleur gagne toujours.", "slogan3": "Oublie les tactiques. Maîtrise les bonus.", "play": "Jouer"},
	"en": {"slogan1": "Build. Think. Dominate.", "slogan2": "No luck, the best always wins.", "slogan3": "Forget tactics. Master the bonuses.", "play": "Play"},
	"es": {"slogan1": "Construye. Piensa. Domina.", "slogan2": "Sin suerte, el mejor siempre gana.", "slogan3": "Olvida las tácticas. Domina los bonos.", "play": "Jugar"},
	"de": {"slogan1": "Baue. Denke. Dominiere.", "slogan2": "Kein Zufall, der Beste gewinnt immer.", "slogan3": "Vergiss Taktiken. Meistere die Boni.", "play": "Spielen"},
	"it": {"slogan1": "Costruisci. Pensa. Domina.", "slogan2": "Nessuna fortuna, il migliore vince sempre.", "slogan3": "Dimentica le tattiche. Padroneggia i bonus.", "play": "Gioca"},
	"pt": {"slogan1": "Constrói. Pensa. Domina.", "slogan2": "Sem sorte, o melhor sempre vence.", "slogan3": "Esqueça as táticas. Domine os bônus.", "play": "Jogar"}
}

# ── COULEURS ÉPINGLES ─────────────────────────────────────────────────────────
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

const SFX_CLICK         = "res://Audio/sfx_click.wav"
const SCENE_COMPETITION = "res://Scenes/competition.tscn"

# ── READY ─────────────────────────────────────────────────────────────────────
func _ready():
	txt_version.text = "V 0.1"
	btn_sound_on.visible = GameState.sound_on
	btn_sound_off.visible = not GameState.sound_on
	if GameState.deco1_color == "":
		card_deco1.deco_index = 1; card_deco1.clickable = true
		card_deco1.generate(); card_deco1.display(); card_deco1.save_to_gamestate_deco1()
	else:
		card_deco1.deco_index = 1; card_deco1.clickable = true
		card_deco1.restore_from_gamestate_deco1(); card_deco1.display()
		if GameState.deco1_pin_color != "":
			card_deco1.btn_pincolor.modulate = PIN_COLORS.get(GameState.deco1_pin_color, Color(1,1,1))
			card_deco1.btn_pincolor.visible = true
	if GameState.deco2_color == "":
		card_deco2.deco_index = 2; card_deco2.clickable = true
		card_deco2.generate(); card_deco2.display(); card_deco2.save_to_gamestate_deco2()
	else:
		card_deco2.deco_index = 2; card_deco2.clickable = true
		card_deco2.restore_from_gamestate_deco2(); card_deco2.display()
		if GameState.deco2_pin_color != "":
			card_deco2.btn_pincolor.modulate = PIN_COLORS.get(GameState.deco2_pin_color, Color(1,1,1))
			card_deco2.btn_pincolor.visible = true
	_apply_translations()

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_slogan1.text = t["slogan1"]; txt_slogan2.text = t["slogan2"]
	txt_slogan3.text = t["slogan3"]; txt_play.text = t["play"]

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if _sprite_hit(btn_play, pos):
		play_click_sound()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(SCENE_COMPETITION); return
	if _sprite_hit(btn_sound_on, pos) and btn_sound_on.visible:
		GameState.sound_on = false; btn_sound_on.visible = false; btn_sound_off.visible = true; return
	if _sprite_hit(btn_sound_off, pos) and btn_sound_off.visible:
		GameState.sound_on = true; btn_sound_on.visible = true; btn_sound_off.visible = false
		play_click_sound(); return

# ── SON ───────────────────────────────────────────────────────────────────────
func play_click_sound():
	if not GameState.sound_on: return
	var player = AudioStreamPlayer.new()
	add_child(player); player.stream = load(SFX_CLICK); player.play()
	await player.finished; player.queue_free()

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
