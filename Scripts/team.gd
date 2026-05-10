extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const CARD_SCENE          = "res://Scenes/card_player.tscn"
const SCENE_DCP           = "res://Scenes/detail_card_player.tscn"
const LONG_PRESS_DURATION = 0.5

const CARD_COLORS = {
	"yellow":  Color(1.0, 0.85, 0.0),
	"orange":  Color(1.0, 0.5,  0.0),
	"red":     Color(0.9, 0.1,  0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"blue":    Color(0.2,  0.5,  1.0),
	"white":   Color(1.0,  1.0,  1.0),
	"special": Color(0.0,  0.8,  0.4),
}

const NOTE_RANGES = {
	"yellow":  "60 - 69",
	"orange":  "70 - 79",
	"red":     "80 - 89",
	"magenta": "90 - 99",
	"blue":    "100 - 131",
	"white":   "40",
	"special": "???",
}

# ── ÉTAT ──────────────────────────────────────────────────────────────────────
var slot_card_ids:       Array      = ["","","","","","","",""]
var slot_card_data:      Array      = [{},{},{},{},{},{},{},{}]
var current_popup_color: String     = ""
var current_popup_cards: Array      = []
var popup_card_nodes:    Array      = []
var drag_active:         bool       = false
var drag_card_data:      Dictionary = {}
var drag_visual:         Node       = null
var press_timer:         float      = 0.0
var press_holding:       bool       = false
var press_card_index:    int        = -1
var touch_start:         Vector2    = Vector2.ZERO

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var btn_help        = $BTN_Help
@onready var lbl_help        = $LBL_Help
@onready var btn_bonus1      = $SlotsBonuses/BTN_SlotBonus1
@onready var btn_bonus2      = $SlotsBonuses/BTN_SlotBonus2

@onready var yellow_bg       = $TotalCards/YellowCards/BTN_CardBackground
@onready var orange_bg       = $TotalCards/OrangeCards/BTN_CardBackground
@onready var red_bg          = $TotalCards/RedCards/BTN_CardBackground
@onready var magenta_bg      = $TotalCards/MagentaCards/BTN_CardBackground
@onready var blue_bg         = $TotalCards/BlueCards/BTN_CardBackground
@onready var white_bg        = $TotalCards/WhiteCards/BTN_CardBackground
@onready var special_bg      = $TotalCards/SpecialCards/BTN_CardBackground

@onready var yellow_counter  = $TotalCards/YellowCards/LBL_Counter
@onready var orange_counter  = $TotalCards/OrangeCards/LBL_Counter
@onready var red_counter     = $TotalCards/RedCards/LBL_Counter
@onready var magenta_counter = $TotalCards/MagentaCards/LBL_Counter
@onready var blue_counter    = $TotalCards/BlueCards/LBL_Counter
@onready var white_counter   = $TotalCards/WhiteCards/LBL_Counter
@onready var special_counter = $TotalCards/SpecialCards/LBL_Counter

@onready var yellow_minmax   = $TotalCards/YellowCards/LBL_NoteMinMax
@onready var orange_minmax   = $TotalCards/OrangeCards/LBL_NoteMinMax
@onready var red_minmax      = $TotalCards/RedCards/LBL_NoteMinMax
@onready var magenta_minmax  = $TotalCards/MagentaCards/LBL_NoteMinMax
@onready var blue_minmax     = $TotalCards/BlueCards/LBL_NoteMinMax
@onready var white_minmax    = $TotalCards/WhiteCards/LBL_NoteMinMax
@onready var special_minmax  = $TotalCards/SpecialCards/LBL_NoteMinMax

@onready var popup_cards     = $PopupCards
@onready var btn_close_popup = $PopupCards/BTN_ClosePopup
@onready var card_grid       = $PopupCards/CNT_ScrollCards/CNT_CardGrid

var slot_nodes: Array = []
var shot_nodes: Array = []

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible = true
	Taskbar._update_border_color()
	lbl_help.visible    = false
	popup_cards.visible = false

	var row1 = $SlotsBonuses/CNT_SlotsCardsPlayers/CNT_Row1
	var row2 = $SlotsBonuses/CNT_SlotsCardsPlayers/CNT_Row2
	for i in range(1, 5):
		slot_nodes.append(row1.get_node("BG_SlotCardPlayer%d" % i))
	for i in range(5, 9):
		slot_nodes.append(row2.get_node("BG_SlotCardPlayer%d" % i))

	var srow1 = $ShotsCompetitions/CNT_ShotsCompetitions/CNT_Row1
	var srow2 = $ShotsCompetitions/CNT_ShotsCompetitions/CNT_Row2
	for i in range(1, 5):
		shot_nodes.append(srow1.get_node("BG_ShotCompetition%d" % i))
	for i in range(5, 9):
		shot_nodes.append(srow2.get_node("BG_ShotCompetition%d" % i))

	_setup_color_cards()
	_setup_counters()

	if not GameState.cards_loaded:
		SquadLoader.squad_loaded.connect(_on_squad_loaded)
		SquadLoader.load_squad()
	else:
		_load_team_data()

func _on_squad_loaded():
	if SquadLoader.squad_loaded.is_connected(_on_squad_loaded):
		SquadLoader.squad_loaded.disconnect(_on_squad_loaded)
	_setup_counters()
	_load_team_data()

# ── SETUP COULEURS ────────────────────────────────────────────────────────────
func _setup_color_cards():
	_set_panel_color(yellow_bg,  CARD_COLORS["yellow"])
	_set_panel_color(orange_bg,  CARD_COLORS["orange"])
	_set_panel_color(red_bg,     CARD_COLORS["red"])
	_set_panel_color(magenta_bg, CARD_COLORS["magenta"])
	_set_panel_color(blue_bg,    CARD_COLORS["blue"])
	_set_panel_color(white_bg,   CARD_COLORS["white"])
	_set_panel_color(special_bg, CARD_COLORS["special"])
	yellow_minmax.text  = NOTE_RANGES["yellow"]
	orange_minmax.text  = NOTE_RANGES["orange"]
	red_minmax.text     = NOTE_RANGES["red"]
	magenta_minmax.text = NOTE_RANGES["magenta"]
	blue_minmax.text    = NOTE_RANGES["blue"]
	white_minmax.text   = NOTE_RANGES["white"]
	special_minmax.text = NOTE_RANGES["special"]

# ── COMPTEURS ─────────────────────────────────────────────────────────────────
func _setup_counters():
	yellow_counter.text  = str(GameState.cards_yellow.size()).lpad(4, "0")
	orange_counter.text  = str(GameState.cards_orange.size()).lpad(4, "0")
	red_counter.text     = str(GameState.cards_red.size()).lpad(4, "0")
	magenta_counter.text = str(GameState.cards_magenta.size()).lpad(4, "0")
	blue_counter.text    = str(GameState.cards_blue.size()).lpad(4, "0")
	white_counter.text   = str(GameState.cards_white.size()).lpad(4, "0")
	special_counter.text = str(GameState.cards_special.size()).lpad(4, "0")

# ── FIREBASE LOAD ─────────────────────────────────────────────────────────────
func _load_team_data():
	Firebase.firestore_success.connect(_on_team_loaded)
	Firebase.firestore_failed.connect(_on_team_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/team", "current_week")

func _on_team_loaded(data: Dictionary):
	_disconnect_team_signals()
	for i in range(8):
		slot_card_ids[i] = data.get("slot_%d" % (i + 1), "")
	_rebuild_slot_card_data()
	_refresh_slots()

func _on_team_failed(_error: String):
	_disconnect_team_signals()
	_refresh_slots()

func _disconnect_team_signals():
	if Firebase.firestore_success.is_connected(_on_team_loaded):
		Firebase.firestore_success.disconnect(_on_team_loaded)
	if Firebase.firestore_failed.is_connected(_on_team_failed):
		Firebase.firestore_failed.disconnect(_on_team_failed)

func _rebuild_slot_card_data():
	var all_cards = SquadLoader.get_all_cards()
	for i in range(8):
		slot_card_data[i] = {}
		if slot_card_ids[i] == "":
			continue
		for card in all_cards:
			if card.get("card_id", "") == slot_card_ids[i]:
				slot_card_data[i] = card
				break

# ── REFRESH SLOTS ─────────────────────────────────────────────────────────────
func _refresh_slots():
	for i in range(8):
		var bg = slot_nodes[i]
		if slot_card_ids[i] != "":
			var c = CARD_COLORS.get(slot_card_data[i].get("color", ""), Color(0.7, 0.7, 0.7))
			_set_panel_color(bg, c)
		else:
			_set_panel_color(bg, Color(1, 1, 1))

# ── FIREBASE SAVE ─────────────────────────────────────────────────────────────
func _save_team():
	var data: Dictionary = {}
	for i in range(8):
		data["slot_%d" % (i + 1)] = slot_card_ids[i]
	Firebase.update_document("managers/" + Firebase.user_id + "/team", "current_week", data)

# ── POPUP CARTES ──────────────────────────────────────────────────────────────
func _open_popup(color: String):
	current_popup_color = color
	var cards = _get_cards_by_color(color).duplicate()
	cards.sort_custom(func(a, b): return int(a.get("note", 0)) > int(b.get("note", 0)))
	current_popup_cards = cards
	_populate_card_grid(cards)
	popup_cards.visible = true

func _close_popup():
	popup_cards.visible = false
	current_popup_color = ""
	current_popup_cards = []
	for child in card_grid.get_children():
		child.queue_free()
	popup_card_nodes.clear()
	_end_drag()

func _get_cards_by_color(color: String) -> Array:
	match color:
		"yellow":
			return GameState.cards_yellow
		"orange":
			return GameState.cards_orange
		"red":
			return GameState.cards_red
		"magenta":
			return GameState.cards_magenta
		"blue":
			return GameState.cards_blue
		"white":
			return GameState.cards_white
		"special":
			return GameState.cards_special
	return []

func _populate_card_grid(cards: Array):
	for child in card_grid.get_children():
		child.queue_free()
	popup_card_nodes.clear()
	for card_data in cards:
		var card = load(CARD_SCENE).instantiate()
		card.clickable          = false
		card.note               = int(card_data.get("note", 0))
		card.color              = card_data.get("color", "yellow")
		card.position1          = card_data.get("position1", "")
		card.position2          = card_data.get("position2", "")
		card.position2_unlocked = int(card_data.get("position2_unlocked", 0))
		card.nationality        = card_data.get("nationality", "")
		card.firstname          = card_data.get("firstname", "")
		card.lastname           = card_data.get("lastname", "")
		card.ball_color         = card_data.get("ball_color", "")
		card.specialty1         = card_data.get("specialty1", "")
		card.specialty2         = card_data.get("specialty2", "")
		card.selected_card_id   = card_data.get("card_id", "")
		if card_data.get("card_id", "") in slot_card_ids:
			card.modulate = Color(0.5, 0.5, 0.5, 0.8)
		card_grid.add_child(card)
		card.display()
		popup_card_nodes.append(card)

# ── PROCESS — appui long ──────────────────────────────────────────────────────
func _process(delta):
	if press_holding and press_card_index >= 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false
			press_timer   = 0.0
			_start_drag_from_popup(press_card_index)

# ── DRAG ──────────────────────────────────────────────────────────────────────
func _start_drag_from_popup(card_index: int):
	if card_index >= current_popup_cards.size():
		return
	var card_data = current_popup_cards[card_index]
	if card_data.get("card_id", "") in slot_card_ids:
		return
	drag_active    = true
	drag_card_data = card_data
	var card       = load(CARD_SCENE).instantiate()
	card.clickable   = false
	card.note        = int(card_data.get("note", 0))
	card.color       = card_data.get("color", "yellow")
	card.position1   = card_data.get("position1", "")
	card.nationality = card_data.get("nationality", "")
	card.firstname   = card_data.get("firstname", "")
	card.lastname    = card_data.get("lastname", "")
	card.ball_color  = card_data.get("ball_color", "")
	card.z_index     = 100
	card.scale       = Vector2(0.45, 0.45)
	add_child(card)
	card.display()
	drag_visual = card

func _drop_on_slot(slot_index: int):
	if not drag_active:
		return
	var card_id = drag_card_data.get("card_id", "")
	if card_id == "":
		return
	slot_card_ids[slot_index]  = card_id
	slot_card_data[slot_index] = drag_card_data
	_end_drag()
	_refresh_slots()
	_populate_card_grid(current_popup_cards)
	_save_team()

func _remove_from_slot(slot_index: int):
	slot_card_ids[slot_index]  = ""
	slot_card_data[slot_index] = {}
	_refresh_slots()
	if popup_cards.visible:
		_populate_card_grid(current_popup_cards)
	_save_team()

func _end_drag():
	drag_active    = false
	drag_card_data = {}
	if drag_visual:
		drag_visual.queue_free()
		drag_visual = null
	press_card_index = -1

# ── OUVRIR DCP ────────────────────────────────────────────────────────────────
func _open_dcp(slot_index: int):
	var data = slot_card_data[slot_index]
	if data.is_empty():
		return
	GameState.selected_note               = int(data.get("note", 0))
	GameState.selected_color              = data.get("color", "")
	GameState.selected_position1          = data.get("position1", "")
	GameState.selected_position2          = data.get("position2", "")
	GameState.selected_position2_unlocked = int(data.get("position2_unlocked", 0))
	GameState.selected_age                = int(data.get("age", 0))
	GameState.selected_height             = int(data.get("height", 0))
	GameState.selected_weight             = int(data.get("weight", 0))
	GameState.selected_nationality        = data.get("nationality", "")
	GameState.selected_specialty1         = data.get("specialty1", "")
	GameState.selected_specialty2         = data.get("specialty2", "")
	GameState.selected_firstname          = data.get("firstname", "")
	GameState.selected_lastname           = data.get("lastname", "")
	GameState.selected_ball_color         = data.get("ball_color", "")
	GameState.selected_strength           = int(data.get("strength", 0))
	GameState.selected_speed              = int(data.get("speed", 0))
	GameState.selected_aggression         = int(data.get("aggression", 0))
	GameState.selected_positioning        = int(data.get("positioning", 0))
	GameState.selected_stamina            = int(data.get("stamina", 0))
	GameState.selected_creativity         = int(data.get("creativity", 0))
	GameState.selected_concentration      = int(data.get("concentration", 0))
	GameState.selected_motivation         = int(data.get("motivation", 0))
	GameState.selected_anticipation       = int(data.get("anticipation", 0))
	GameState.selected_communication      = int(data.get("communication", 0))
	GameState.selected_card_id            = data.get("card_id", "")
	GameState.selected_deco_index         = 0
	GameState.previous_scene              = "res://Scenes/team.tscn"
	get_tree().change_scene_to_file(SCENE_DCP)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventMouseMotion:
		if press_holding and event.position.distance_to(touch_start) > 15:
			press_holding = false
			press_timer   = 0.0
		if drag_active and drag_visual:
			drag_visual.position = event.position - Vector2(50, 75)

func _on_press(pos: Vector2):
	if _sprite_hit(btn_help, pos):
		lbl_help.visible = not lbl_help.visible
		return
	if lbl_help.visible:
		lbl_help.visible = false
		return

	if popup_cards.visible:
		if _sprite_hit(btn_close_popup, pos):
			_close_popup()
			return

	if _label_hit(btn_bonus1, pos):
		pass  # TODO : bonus.tscn
		return
	if _label_hit(btn_bonus2, pos):
		pass  # TODO : bonus.tscn
		return

	if not popup_cards.visible:
		if _panel_hit(yellow_bg, pos):  _open_popup("yellow");  return
		if _panel_hit(orange_bg, pos):  _open_popup("orange");  return
		if _panel_hit(red_bg, pos):     _open_popup("red");     return
		if _panel_hit(magenta_bg, pos): _open_popup("magenta"); return
		if _panel_hit(blue_bg, pos):    _open_popup("blue");    return
		if _panel_hit(white_bg, pos):   _open_popup("white");   return
		if _panel_hit(special_bg, pos): _open_popup("special"); return

	if popup_cards.visible and not drag_active:
		for i in range(popup_card_nodes.size()):
			var card = popup_card_nodes[i]
			if card.bg_card_background.get_global_rect().has_point(pos):
				press_card_index = i
				press_holding    = true
				press_timer      = 0.0
				return

	for i in range(8):
		if _panel_hit(slot_nodes[i], pos):
			if slot_card_ids[i] != "":
				_open_dcp(i)
			return

func _on_release(pos: Vector2):
	press_holding = false
	press_timer   = 0.0
	if not drag_active:
		return
	for i in range(8):
		if _panel_hit(slot_nodes[i], pos):
			_drop_on_slot(i)
			return
	_end_drag()

# ── PANEL COLOR ───────────────────────────────────────────────────────────────
func _set_panel_color(panel: PanelContainer, c: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = c
	panel.add_theme_stylebox_override("panel", style)

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _panel_hit(panel: PanelContainer, pos: Vector2) -> bool:
	if panel == null or not panel.visible: return false
	return panel.get_global_rect().has_point(pos)

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
