extends Node2D

@onready var btn_sound_on  = $BTN_SoundOn
@onready var btn_sound_off = $BTN_SoundOff
@onready var card_deco1    = $Card_Player1
@onready var card_deco2    = $Card_Player2
@onready var lbl_version   = $LBL_Version
@onready var btn_play      = $BTN_Play
@onready var lbl_slogan1   = $LBL_Slogan1
@onready var lbl_slogan2   = $LBL_Slogan2
@onready var lbl_slogan3   = $LBL_Slogan3

# ── TRADUCTIONS — slogans uniquement ──────────────────────────────────────────
const TRANSLATIONS = {
	"fr": {
		"slogan1": "Construis. Pense. Domine.",
		"slogan2": "Pas de hasard, le meilleur gagne toujours.",
		"slogan3": "Oublie les tactiques. Maîtrise les bonus."
	},
	"en": {
		"slogan1": "Build. Think. Dominate.",
		"slogan2": "No luck, the best always wins.",
		"slogan3": "Forget tactics. Master the bonuses."
	},
	"es": {
		"slogan1": "Construye. Piensa. Domina.",
		"slogan2": "Sin suerte, el mejor siempre gana.",
		"slogan3": "Olvida las tácticas. Domina los bonos."
	},
	"de": {
		"slogan1": "Baue. Denke. Dominiere.",
		"slogan2": "Kein Zufall, der Beste gewinnt immer.",
		"slogan3": "Vergiss Taktiken. Meistere die Boni."
	},
	"it": {
		"slogan1": "Costruisci. Pensa. Domina.",
		"slogan2": "Nessuna fortuna, il migliore vince sempre.",
		"slogan3": "Dimentica le tattiche. Padroneggia i bonus."
	},
	"pt": {
		"slogan1": "Constrói. Pensa. Domina.",
		"slogan2": "Sem sorte, o melhor sempre vence.",
		"slogan3": "Esqueça as táticas. Domine os bônus."
	}
}

const SFX_CLICK      = "res://Audio/sfx_click.wav"
const SCENE_SCHEDULE = "res://Scenes/schedule.tscn"

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible       = false
	lbl_version.text      = "V 0.1"
	btn_sound_on.visible  = GameState.sound_on
	btn_sound_off.visible = not GameState.sound_on
	if GameState.deco1_color == "":
		card_deco1.deco_index = 1; card_deco1.clickable = true
		card_deco1.generate(); card_deco1.display(); card_deco1.save_to_gamestate_deco1()
	else:
		card_deco1.deco_index = 1; card_deco1.clickable = true
		card_deco1.restore_from_gamestate_deco1(); card_deco1.display()
	if GameState.deco2_color == "":
		card_deco2.deco_index = 2; card_deco2.clickable = true
		card_deco2.generate(); card_deco2.display(); card_deco2.save_to_gamestate_deco2()
	else:
		card_deco2.deco_index = 2; card_deco2.clickable = true
		card_deco2.restore_from_gamestate_deco2(); card_deco2.display()
	_apply_translations()
	btn_play.gui_input.connect(_on_btn_play_input)

# ── TRADUCTIONS ────────────────────────────────────────────────────────────────
func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	lbl_slogan1.text = t["slogan1"]
	lbl_slogan2.text = t["slogan2"]
	lbl_slogan3.text = t["slogan3"]
	btn_play.text    = "Play"

# ── BTN_Play — Label → gui_input ─────────────────────────────────────────────
func _on_btn_play_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		play_click_sound()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(SCENE_SCHEDULE)

# ── BTN_SoundOn / SoundOff — Sprite2D → _input ───────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if _sprite_hit(btn_sound_on, pos) and btn_sound_on.visible:
		GameState.sound_on    = false
		btn_sound_on.visible  = false
		btn_sound_off.visible = true
		return
	if _sprite_hit(btn_sound_off, pos) and btn_sound_off.visible:
		GameState.sound_on    = true
		btn_sound_on.visible  = true
		btn_sound_off.visible = false
		play_click_sound()
		return

# ── SON ────────────────────────────────────────────────────────────────────────
func play_click_sound():
	if not GameState.sound_on: return
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(SFX_CLICK)
	player.play()
	await player.finished
	player.queue_free()

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
