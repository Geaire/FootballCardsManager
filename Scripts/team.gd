extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const SCENE_BONUS   = "res://Scenes/bonus.tscn"
const CARD_SCENE    = preload("res://Scenes/card_player.tscn")
const SHOT_TIMES    = {
	1:"0h - 3h", 2:"3h - 6h", 3:"6h - 9h", 4:"9h - 12h",
	5:"12h - 15h", 6:"15h - 18h", 7:"18h - 21h", 8:"21h - 24h"
}
const LONG_PRESS_DURATION = 0.5

const CARD_COLORS_GODOT = {
	"yellow":  Color(1.0, 0.85, 0.0),
	"orange":  Color(1.0, 0.5,  0.0),
	"red":     Color(0.9, 0.1,  0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"white":   Color(1.0, 1.0,  1.0),
	"blue":    Color(0.2, 0.5,  1.0),
	"special": Color(0.0, 0.8,  0.4),
}

const NOTE_RANGES = {
	"yellow":  "60 - 69",
	"orange":  "70 - 79",
	"red":     "80 - 89",
	"magenta": "90 - 99",
	"white":   "40 - 112",
	"blue":    "100 - 131",
	"special": "100 - 131",
}

const COMP_COLORS = {
	"championnat_classique": Color(0.0,   0.200, 0.400),
	"coupe_classique":       Color(0.0,   0.808, 0.820),
	"championnat_pantheon":  Color(0.416, 0.051, 0.678),
	"coupe_pantheon":        Color(1.0,   0.412, 0.706),
	"championnat_jeunes":    Color(0.545, 0.271, 0.075),
	"coupe_jeunes":          Color(0.722, 0.722, 0.722),
	"championnat_asso":      Color(0.502, 0.0,   0.125),
	"coupe_asso":            Color(1.0,   0.420, 0.420),
	"championnat_special":   Color(0.176, 0.416, 0.310),
	"autre":                 Color(0.584, 0.835, 0.698),
}

const TRANSLATIONS = {
	"fr": {
		"choose_bonus":  "Clic pour choisir un Bonus",
		"missing":       "Joueurs manquants : ",
		"validate":      "Valider",
		"btn_ok":        "OK",
	},
	"en": {
		"choose_bonus":  "Click to choose a Bonus",
		"missing":       "Missing players: ",
		"validate":      "Validate",
		"btn_ok":        "OK",
	},
	"es": {
		"choose_bonus":  "Clic para elegir un Bono",
		"missing":       "Jugadores faltantes: ",
		"validate":      "Validar",
		"btn_ok":        "OK",
	},
	"de": {
		"choose_bonus":  "Klicken um Bonus zu wählen",
		"missing":       "Fehlende Spieler: ",
		"validate":      "Bestätigen",
		"btn_ok":        "OK",
	},
	"it": {
		"choose_bonus":  "Clicca per scegliere un Bonus",
		"missing":       "Giocatori mancanti: ",
		"validate":      "Valida",
		"btn_ok":        "OK",
	},
	"pt": {
		"choose_bonus":  "Clique para escolher um Bônus",
		"missing":       "Jogadores em falta: ",
		"validate":      "Validar",
		"btn_ok":        "OK",
	},
}

# ── ÉTAT ──────────────────────────────────────────────────────────────────────
var active_shot:          int        = -1
var popup_open:           bool       = false
var popup_color:          String     = ""
var card_instances_popup: Array      = []
var bonus1_id:            String     = ""
var bonus2_id:            String     = ""
var player_slots:         Array      = ["","","","","","","",""]
var player_instances:     Array      = [null,null,null,null,null,null,null,null]
var drag_active:          bool       = false
var drag_card_id:         String     = ""
var drag_card_dict:       Dictionary = {}
var drag_visual:          Node       = null
var drag_from_slot:       int        = -1
var touch_start:          Vector2    = Vector2.ZERO
var press_slot:           int        = -1
var press_timer:          float      = 0.0
var press_holding:        bool       = false
var schedule_data:        Dictionary = {}

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var slot_bonus1     = $Slots_BonusPlayers/SlotBonus1
@onready var slot_bonus2     = $Slots_BonusPlayers/SlotBonus2
@onready var slot_card_nodes = [
	$Slots_BonusPlayers/SlotCardPlayer1,
	$Slots_BonusPlayers/SlotCardPlayer2,
	$Slots_BonusPlayers/SlotCardPlayer3,
	$Slots_BonusPlayers/SlotCardPlayer4,
	$Slots_BonusPlayers/SlotCardPlayer5,
	$Slots_BonusPlayers/SlotCardPlayer6,
	$Slots_BonusPlayers/SlotCardPlayer7,
	$Slots_BonusPlayers/SlotCardPlayer8,
]
@onready var cards_yellow  = $TotalCardsPlayer/CardsYellow
@onready var cards_orange  = $TotalCardsPlayer/CardsOrange
@onready var cards_red     = $TotalCardsPlayer/CardsRed
@onready var cards_magenta = $TotalCardsPlayer/CardsMagenta
@onready var cards_white   = $TotalCardsPlayer/CardsWhite
@onready var cards_blue    = $TotalCardsPlayer/CardsBlue
@onready var cards_special = $TotalCardsPlayer/CardsSpecial
@onready var shot_nodes = [
	$Shots_Competitions/Shot1, $Shots_Competitions/Shot2,
	$Shots_Competitions/Shot3, $Shots_Competitions/Shot4,
	$Shots_Competitions/Shot5, $Shots_Competitions/Shot6,
	$Shots_Competitions/Shot7, $Shots_Competitions/Shot8,
]
@onready var popup_cards     = $Popup_Cards
@onready var btn_close_popup = $Popup_Cards/BTN_ClosePopup
@onready var card_grid       = $Popup_Cards/ScrollContainer/CardGrid
@onready var overlay_terrain    = $Overlay_Terrain
@onready var btn_close_overlay  = $Overlay_Terrain/BTN_CloseOverlay
@onready var btn_validate       = $Overlay_Terrain/BTN_Validate
@onready var txt_validate       = $Overlay_Terrain/TXT_Validate
@onready var txt_missing        = $Overlay_Terrain/TXT_MissingPlayers

var color_card_nodes: Dictionary = {}

# ── READY ─────────────────────────────────────────────────────────────────────
func _ready():
	color_card_nodes = {
		"yellow":  cards_yellow,  "orange":  cards_orange,
		"red":     cards_red,     "magenta": cards_magenta,
		"white":   cards_white,   "blue":    cards_blue,
		"special": cards_special,
	}
	popup_cards.visible     = false
	overlay_terrain.visible = false
	_apply_translations()
	_setup_color_cards()
	_load_schedule_data()
	_update_active_shot()
	if GameState.bonus_slot_target > 0:
		_apply_bonus_from_bonus_scene()

func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	slot_bonus1.text  = t["choose_bonus"]
	slot_bonus2.text  = t["choose_bonus"]
	txt_validate.text = t["validate"]

func _setup_color_cards():
	for color in color_card_nodes:
		var node  = color_card_nodes[color]
		var bg    = node.get_node_or_null("CardBackground")
		var notes = node.get_node_or_null("NoteMinMax")
		var count = node.get_node_or_null("TXT_Count")
		if bg:    bg.modulate = CARD_COLORS_GODOT[color]
		if notes: notes.text  = NOTE_RANGES[color]
		if count:
			count.text = str(SquadLoader.get_cards_by_color(color).size())

# ── SCHEDULE ──────────────────────────────────────────────────────────────────
func _load_schedule_data():
	Firebase.firestore_success.connect(_on_schedule_loaded)
	Firebase.firestore_failed.connect(_on_schedule_failed)
	Firebase.get_document("managers/" + Firebase.user_id, "schedule")

func _on_schedule_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_schedule_loaded):
		Firebase.firestore_success.disconnect(_on_schedule_loaded)
	if Firebase.firestore_failed.is_connected(_on_schedule_failed):
		Firebase.firestore_failed.disconnect(_on_schedule_failed)
	schedule_data = data
	_refresh_shots()
	_load_team_composition()

func _on_schedule_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_schedule_loaded):
		Firebase.firestore_success.disconnect(_on_schedule_loaded)
	if Firebase.firestore_failed.is_connected(_on_schedule_failed):
		Firebase.firestore_failed.disconnect(_on_schedule_failed)
	_refresh_shots()

func _refresh_shots():
	for i in range(8):
		var shot_node = shot_nodes[i]
		var bg        = shot_node.get_node_or_null("CardBackground")
		var txt_time  = shot_node.get_node_or_null("TXT_Time")
		var txt_comp  = shot_node.get_node_or_null("TXT_Competition")
		var ovl_lock  = shot_node.get_node_or_null("OVL_Lock")
		if txt_time: txt_time.text = SHOT_TIMES[i + 1]
		var key       = "shot_%d" % (i + 1)
		var comp      = schedule_data.get(key, {})
		var comp_name = comp.get("competition", "")
		var comp_type = comp.get("type", "")
		if txt_comp: txt_comp.text = comp_name
		var is_active = (i + 1 == active_shot) and comp_name != ""
		if bg:
			if is_active:
				bg.modulate = COMP_COLORS.get(comp_type, Color(0.3, 0.3, 0.3))
			else:
				bg.modulate = Color(0.3, 0.3, 0.3)
		if ovl_lock:
			ovl_lock.visible = not is_active

func _update_active_shot():
	var hour = Time.get_datetime_dict_from_system()["hour"]
	if   hour < 3:  active_shot = 1
	elif hour < 6:  active_shot = 2
	elif hour < 9:  active_shot = 3
	elif hour < 12: active_shot = 4
	elif hour < 15: active_shot = 5
	elif hour < 18: active_shot = 6
	elif hour < 21: active_shot = 7
	else:           active_shot = 8

# ── COMPOSITION ───────────────────────────────────────────────────────────────
func _load_team_composition():
	if active_shot < 1:
		return
	Firebase.firestore_success.connect(_on_composition_loaded)
	Firebase.firestore_failed.connect(_on_composition_failed)
	Firebase.get_document(
		"managers/" + Firebase.user_id + "/team_composition",
		"shot_%d" % active_shot)

func _on_composition_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_composition_loaded):
		Firebase.firestore_success.disconnect(_on_composition_loaded)
	if Firebase.firestore_failed.is_connected(_on_composition_failed):
		Firebase.firestore_failed.disconnect(_on_composition_failed)
	bonus1_id = data.get("bonus1_id", "")
	bonus2_id = data.get("bonus2_id", "")
	var b1_players = data.get("bonus1_players", [])
	var b2_players = data.get("bonus2_players", [])
	var all_players = b1_players + b2_players
	for i in range(min(all_players.size(), 8)):
		player_slots[i] = all_players[i]
	_refresh_bonus_display()
	_refresh_player_slots()

func _on_composition_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_composition_loaded):
		Firebase.firestore_success.disconnect(_on_composition_loaded)
	if Firebase.firestore_failed.is_connected(_on_composition_failed):
		Firebase.firestore_failed.disconnect(_on_composition_failed)

func _save_team_composition():
	if active_shot < 1:
		return
	var max_slots  = 8 if bonus2_id == "" else 4
	var b1_players = []
	var b2_players = []
	for i in range(min(max_slots, 8)):
		if player_slots[i] != "":
			b1_players.append(player_slots[i])
	if bonus2_id != "":
		for i in range(4, 8):
			if player_slots[i] != "":
				b2_players.append(player_slots[i])
	Firebase.update_document(
		"managers/" + Firebase.user_id + "/team_composition",
		"shot_%d" % active_shot, {
			"bonus1_id":      bonus1_id,
			"bonus2_id":      bonus2_id,
			"bonus1_players": b1_players,
			"bonus2_players": b2_players,
		})

# ── BONUS ─────────────────────────────────────────────────────────────────────
func _apply_bonus_from_bonus_scene():
	var target    = GameState.bonus_slot_target
	var new_bonus = GameState.selected_bonus1
	if target == 1:
		bonus1_id = new_bonus
	elif target == 2:
		bonus2_id = new_bonus
	GameState.bonus_slot_target = 0
	_refresh_bonus_display()
	_save_team_composition()

func _refresh_bonus_display():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	slot_bonus1.text = bonus1_id if bonus1_id != "" else t["choose_bonus"]
	slot_bonus2.text = bonus2_id if bonus2_id != "" else t["choose_bonus"]
	var max_slots = 8 if bonus2_id == "" else 4
	for i in range(8):
		slot_card_nodes[i].visible = (i < max_slots)

# ── SLOTS JOUEURS ─────────────────────────────────────────────────────────────
func _refresh_player_slots():
	for i in range(8):
		if player_instances[i] != null:
			player_instances[i].queue_free()
			player_instances[i] = null
		if player_slots[i] != "":
			_spawn_card_in_slot(i)

func _spawn_card_in_slot(idx: int):
	var d = _find_card_by_id(player_slots[idx])
	if d.is_empty():
		return
	var card = CARD_SCENE.instantiate()
	card.note               = int(d.get("note", 0))
	card.color              = str(d.get("color", ""))
	card.position1          = str(d.get("position1", ""))
	card.position2          = str(d.get("position2", ""))
	card.position2_unlocked = int(d.get("position2_unlocked", 0))
	card.age                = int(d.get("age", 0))
	card.height             = int(d.get("height", 0))
	card.weight             = int(d.get("weight", 0))
	card.nationality        = str(d.get("nationality", ""))
	card.specialty1         = str(d.get("specialty1", ""))
	card.specialty2         = str(d.get("specialty2", ""))
	card.firstname          = str(d.get("firstname", ""))
	card.lastname           = str(d.get("lastname", ""))
	card.pin_color          = str(d.get("pin_color", ""))
	card.strength           = int(d.get("strength", 0))
	card.speed              = int(d.get("speed", 0))
	card.aggression         = int(d.get("aggression", 0))
	card.positioning        = int(d.get("positioning", 0))
	card.stamina            = int(d.get("stamina", 0))
	card.creativity         = int(d.get("creativity", 0))
	card.concentration      = int(d.get("concentration", 0))
	card.motivation         = int(d.get("motivation", 0))
	card.anticipation       = int(d.get("anticipation", 0))
	card.communication      = int(d.get("communication", 0))
	card.clickable          = false
	card.display()
	add_child(card)
	card.global_position    = slot_card_nodes[idx].global_position
	player_instances[idx]   = card

func _find_card_by_id(card_id: String) -> Dictionary:
	for arr in [GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
				GameState.cards_magenta, GameState.cards_blue, GameState.cards_white,
				GameState.cards_special]:
		for d in arr:
			if d.get("card_id", "") == card_id:
				return d
	return {}

# ── POPUP CARTES ──────────────────────────────────────────────────────────────
func _open_popup(color: String):
	popup_color = color
	popup_open  = true
	popup_cards.visible         = true
	Taskbar.visible             = false
	$Shots_Competitions.visible = false
	for child in card_grid.get_children():
		child.queue_free()
	card_instances_popup = []
	for d in SquadLoader.get_cards_by_color(color):
		var card = CARD_SCENE.instantiate()
		card.note               = int(d.get("note", 0))
		card.color              = str(d.get("color", ""))
		card.position1          = str(d.get("position1", ""))
		card.position2          = str(d.get("position2", ""))
		card.position2_unlocked = int(d.get("position2_unlocked", 0))
		card.age                = int(d.get("age", 0))
		card.height             = int(d.get("height", 0))
		card.weight             = int(d.get("weight", 0))
		card.nationality        = str(d.get("nationality", ""))
		card.specialty1         = str(d.get("specialty1", ""))
		card.specialty2         = str(d.get("specialty2", ""))
		card.firstname          = str(d.get("firstname", ""))
		card.lastname           = str(d.get("lastname", ""))
		card.pin_color          = str(d.get("pin_color", ""))
		card.clickable          = false
		card.display()
		if d.get("card_id","") in player_slots:
			card.modulate = Color(0.4, 0.4, 0.4)
		card_grid.add_child(card)
		card_instances_popup.append({"node": card, "data": d})

func _close_popup():
	popup_open              = false
	popup_cards.visible     = false
	Taskbar.visible         = true
	$Shots_Competitions.visible = true
	for child in card_grid.get_children():
		child.queue_free()
	card_instances_popup = []
	if drag_active:
		_end_drag()

# ── PROCESS — appui long ──────────────────────────────────────────────────────
func _process(delta):
	if press_holding and press_slot >= 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false
			press_timer   = 0.0
			_remove_card_from_slot(press_slot)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventMouseMotion:
		if press_holding and event.position.distance_to(touch_start) > 10:
			press_holding = false; press_timer = 0.0
		if drag_active and drag_visual:
			drag_visual.position = event.position - Vector2(50, 70)

func _on_press(pos: Vector2):
	# Popup cartes ouvert
	if popup_open:
		if _sprite_hit(btn_close_popup, pos):
			_close_popup(); return
		for item in card_instances_popup:
			var card = item["node"]
			if _card_hit_global(card, pos):
				var d = item["data"]
				if d.get("card_id","") not in player_slots:
					_start_drag(d, -1)
				return
		return
	# Overlay terrain ouvert
	if overlay_terrain.visible:
		if _sprite_hit(btn_close_overlay, pos):
			overlay_terrain.visible = false; return
		if _sprite_hit(btn_validate, pos):
			_validate_composition(); return
		return
	# Bonus slots
	if _label_hit(slot_bonus1, pos):
		GameState.bonus_slot_target = 1
		GameState.previous_scene    = "res://Scenes/team.tscn"
		get_tree().change_scene_to_file(SCENE_BONUS); return
	if _label_hit(slot_bonus2, pos):
		GameState.bonus_slot_target = 2
		GameState.previous_scene    = "res://Scenes/team.tscn"
		get_tree().change_scene_to_file(SCENE_BONUS); return
	# Cartes couleurs → popup
	for color in color_card_nodes:
		var node = color_card_nodes[color]
		var bg   = node.get_node_or_null("CardBackground")
		if bg and _sprite_hit(bg, pos):
			_open_popup(color); return
	# Slots joueurs → appui long
	for i in range(8):
		if slot_card_nodes[i].visible and player_slots[i] != "":
			if _sprite_hit(slot_card_nodes[i], pos) or _card_hit_global(player_instances[i], pos):
				press_slot = i; press_holding = true; press_timer = 0.0; return
	# Shot actif → overlay
	if active_shot >= 1:
		var shot = shot_nodes[active_shot - 1]
		var bg   = shot.get_node_or_null("CardBackground")
		if bg and _sprite_hit(bg, pos):
			_open_overlay(); return

func _on_release(pos: Vector2):
	press_holding = false; press_timer = 0.0
	if not drag_active:
		return
	for i in range(8):
		if slot_card_nodes[i].visible and _sprite_hit(slot_card_nodes[i], pos):
			_drop_card_on_slot(i); return
	_end_drag()

# ── DRAG ──────────────────────────────────────────────────────────────────────
func _start_drag(card_dict: Dictionary, from_slot: int):
	drag_active    = true
	drag_card_id   = card_dict.get("card_id", "")
	drag_card_dict = card_dict
	drag_from_slot = from_slot
	drag_visual    = Label.new()
	drag_visual.text     = card_dict.get("firstname","") + " " + card_dict.get("lastname","")
	drag_visual.modulate = CARD_COLORS_GODOT.get(card_dict.get("color",""), Color(1,1,1))
	add_child(drag_visual)

func _end_drag():
	drag_active = false; drag_card_id = ""; drag_card_dict = {}; drag_from_slot = -1
	if drag_visual:
		drag_visual.queue_free(); drag_visual = null

func _drop_card_on_slot(slot_idx: int):
	var max_slots = 8 if bonus2_id == "" else 4
	if slot_idx >= max_slots:
		_end_drag(); return
	if player_slots[slot_idx] != "" and drag_from_slot >= 0:
		var temp = player_slots[slot_idx]
		player_slots[slot_idx]       = drag_card_id
		player_slots[drag_from_slot] = temp
	else:
		if drag_from_slot >= 0:
			player_slots[drag_from_slot] = ""
		player_slots[slot_idx] = drag_card_id
	_end_drag()
	_refresh_player_slots()
	_save_team_composition()

func _remove_card_from_slot(idx: int):
	player_slots[idx] = ""
	if player_instances[idx] != null:
		player_instances[idx].queue_free()
		player_instances[idx] = null
	press_slot = -1
	_refresh_player_slots()
	_save_team_composition()

# ── OVERLAY TERRAIN ───────────────────────────────────────────────────────────
func _open_overlay():
	overlay_terrain.visible = true
	var t      = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	var filled = 0
	for s in player_slots:
		if s != "": filled += 1
	var missing = 11 - filled
	txt_missing.text = t["missing"] + str(missing) if missing > 0 else ""

func _validate_composition():
	overlay_terrain.visible = false
	_save_team_composition()

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible:
		return false
	return label.get_global_rect().has_point(pos)

func _card_hit_global(card: Node, pos: Vector2) -> bool:
	if card == null:
		return false
	return Rect2(card.global_position - Vector2(50, 70), Vector2(100, 140)).has_point(pos)
