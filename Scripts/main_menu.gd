extends Node2D

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var btn_sound_on  = $BTN_SoundOn
@onready var btn_sound_off = $BTN_SoundOff
@onready var card_deco1    = $Card_Player1
@onready var card_deco2    = $Card_Player2
@onready var lbl_version   = $LBL_Version
@onready var btn_play      = $BTN_Play
@onready var lbl_slogan1   = $LBL_Slogan1
@onready var lbl_slogan2   = $LBL_Slogan2
@onready var lbl_slogan3   = $LBL_Slogan3

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const SCENE_TEAM = "res://Scenes/team.tscn"
const SFX_CLICK  = "res://Audio/sfx_click.wav"

# Les slogans sont l'identité du jeu — traduits dans les 6 langues.
# Tout le reste de la scène est en anglais fixe.
const SLOGANS = {
	"fr": ["Construis. Pense. Domine.", "Pas de hasard, le meilleur gagne toujours.", "Oublie les tactiques. Maîtrise les bonus."],
	"en": ["Build. Think. Dominate.",   "No luck, the best always wins.",             "Forget tactics. Master the bonuses."],
	"es": ["Construye. Piensa. Domina.","Sin suerte, el mejor siempre gana.",         "Olvida las tácticas. Domina los bonos."],
	"de": ["Baue. Denke. Dominiere.",   "Kein Zufall, der Beste gewinnt immer.",      "Vergiss Taktiken. Meistere die Boni."],
	"it": ["Costruisci. Pensa. Domina.","Nessuna fortuna, il migliore vince sempre.", "Dimentica le tattiche. Padroneggia i bonus."],
	"pt": ["Constrói. Pensa. Domina.",  "Sem sorte, o melhor sempre vence.",          "Esqueça as táticas. Domine os bônus."],
}

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible      = true
	Taskbar._update_border_color
	lbl_version.text     = "V 0.1"
	btn_play.text        = "Play"
	btn_sound_on.visible  = GameState.sound_on
	btn_sound_off.visible = not GameState.sound_on

	# Slogans traduits
	var s = SLOGANS.get(GameState.language, SLOGANS["en"])
	lbl_slogan1.text = s[0]; lbl_slogan2.text = s[1]; lbl_slogan3.text = s[2]

	# Cartes déco
	_setup_deco_card(card_deco1, 1, GameState.deco1_color)
	_setup_deco_card(card_deco2, 2, GameState.deco2_color)

func _setup_deco_card(card: Node2D, idx: int, saved_color: String):
	card.deco_index = idx
	card.clickable  = true
	if saved_color == "":
		card.generate()
		card.display()
		if idx == 1: card.save_to_gamestate_deco1()
		else:        card.save_to_gamestate_deco2()
	else:
		if idx == 1: card.restore_from_gamestate_deco1()
		else:        card.restore_from_gamestate_deco2()
		card.display()

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position

	if _label_hit(btn_play, pos):
		_play_click_sound()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(SCENE_TEAM)
		return

	if _sprite_hit(btn_sound_on, pos) and btn_sound_on.visible:
		GameState.sound_on    = false
		btn_sound_on.visible  = false
		btn_sound_off.visible = true
		return

	if _sprite_hit(btn_sound_off, pos) and btn_sound_off.visible:
		GameState.sound_on    = true
		btn_sound_on.visible  = true
		btn_sound_off.visible = false
		_play_click_sound()
		return

# ── SON ───────────────────────────────────────────────────────────────────────
func _play_click_sound():
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

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
