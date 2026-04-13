extends Node2D

# ── COULEURS COMPETITIONS ─────────────────────────────────────────────────────
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

# ── CATALOGUE SEMAINE — modifier chaque semaine ───────────────────────────────
# Format : [nom_affiche, type_competition]
const WEEKLY_CATALOGUE = [
	["Championnat Classique", "championnat_classique"],
	["Coupe Classique",       "coupe_classique"],
	["Championnat Panthéon",  "championnat_pantheon"],
	["Coupe Panthéon",        "coupe_pantheon"],
	["Championnat Jeunes",    "championnat_jeunes"],
	["Matchs Amicaux",        "autre"],
]

# ── PAIRES SHOTS CHAMPIONNAT ──────────────────────────────────────────────────
const CHAMPIONSHIP_PAIRS = {1: 4, 2: 5, 3: 6, 4: 7, 5: 8}
const CHAMPIONSHIP_TYPES = [
	"championnat_classique","championnat_pantheon",
	"championnat_jeunes","championnat_asso","championnat_special"
]

# ── HORAIRES ──────────────────────────────────────────────────────────────────
const SHOT_TIMES = {
	1: "0h - 3h",   2: "3h - 6h",   3: "6h - 9h",   4: "9h - 12h",
	5: "12h - 15h", 6: "15h - 18h", 7: "18h - 21h", 8: "21h - 24h"
}

# ── ETAT ──────────────────────────────────────────────────────────────────────
var shot_data: Dictionary = {}
var drag_active: bool      = false
var drag_comp_name: String = ""
var drag_comp_type: String = ""
var drag_origin_index: int = -1
var drag_visual: Label     = null

@onready var catalogue = $Catalogue

var shot_nodes: Array  = []
var comp_labels: Array = []

func _ready():
	for i in range(1, 9):
		shot_data[i] = {}
		shot_nodes.append(get_node("Shot_%d" % i))
	for i in range(1, WEEKLY_CATALOGUE.size() + 1):
		comp_labels.append(catalogue.get_node("TXT_Competition%d" % i))
	_setup_shot_times()
	_setup_catalogue()
	_refresh_shots()
	_check_lock()

func _setup_shot_times():
	for i in range(1, 9):
		shot_nodes[i-1].get_node("TXT_Time").text = SHOT_TIMES[i]

func _setup_catalogue():
	for i in range(WEEKLY_CATALOGUE.size()):
		var entry = WEEKLY_CATALOGUE[i]
		var lbl   = comp_labels[i]
		lbl.text     = entry[0]
		lbl.modulate = COMP_COLORS[entry[1]]
		lbl.visible  = true

func _refresh_shots():
	for i in range(1, 9):
		var shot  = shot_nodes[i - 1]
		var txt_c = shot.get_node("TXT_Competition")
		var bg    = shot.get_node("Card_Background_Shot")
		if shot_data[i].is_empty():
			txt_c.text  = ""
			bg.modulate = Color(1.0, 1.0, 1.0)
		else:
			txt_c.text  = shot_data[i]["name"]
			bg.modulate = COMP_COLORS[shot_data[i]["type"]]
	_update_shot_availability()

func _update_shot_availability():
	if not drag_active or drag_comp_type not in CHAMPIONSHIP_TYPES:
		for i in range(1, 9):
			shot_nodes[i-1].modulate = Color(1.0, 1.0, 1.0)
		return
	for i in range(1, 9):
		shot_nodes[i-1].modulate = Color(1.0,1.0,1.0) if _is_shot_available_for_champ(i) else Color(0.4,0.4,0.4)

func _is_shot_available_for_champ(slot: int) -> bool:
	if slot > 5:
		return false
	var pair = CHAMPIONSHIP_PAIRS[slot]
	if not shot_data[slot].is_empty():
		if shot_data[slot].get("name","") != drag_comp_name:
			return false
	if not shot_data[pair].is_empty():
		return false
	return true

func _check_lock():
	var now = Time.get_datetime_dict_from_system()
	var is_locked = (now["weekday"] == 0 and now["hour"] >= 18)
	for i in range(1, 9):
		shot_nodes[i-1].get_node("OVL_Lock").visible = is_locked

func _drop_on_shot(slot: int):
	if not shot_data[slot].is_empty() and slot != drag_origin_index:
		_end_drag()
		return
	if drag_comp_type in CHAMPIONSHIP_TYPES:
		if not _is_shot_available_for_champ(slot):
			_end_drag()
			return
		shot_data[slot] = {"name": drag_comp_name, "type": drag_comp_type}
		shot_data[CHAMPIONSHIP_PAIRS[slot]] = {"name": drag_comp_name + " (2)", "type": drag_comp_type}
	else:
		shot_data[slot] = {"name": drag_comp_name, "type": drag_comp_type}
	if drag_origin_index > 0:
		_clear_shot(drag_origin_index)
	_end_drag()
	_refresh_shots()

func _clear_shot(slot: int):
	var t = shot_data[slot].get("type", "")
	if t in CHAMPIONSHIP_TYPES:
		if CHAMPIONSHIP_PAIRS.has(slot):
			shot_data[CHAMPIONSHIP_PAIRS[slot]] = {}
		for k in CHAMPIONSHIP_PAIRS:
			if CHAMPIONSHIP_PAIRS[k] == slot:
				shot_data[k] = {}
	shot_data[slot] = {}

func _start_drag(name: String, type: String, origin: int):
	drag_active       = true
	drag_comp_name    = name
	drag_comp_type    = type
	drag_origin_index = origin
	drag_visual = Label.new()
	drag_visual.text     = name
	drag_visual.modulate = COMP_COLORS[type]
	add_child(drag_visual)
	_update_shot_availability()

func _end_drag():
	drag_active = false; drag_comp_name = ""; drag_comp_type = ""; drag_origin_index = -1
	if drag_visual: drag_visual.queue_free(); drag_visual = null
	_update_shot_availability()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed: _on_press(event.position)
		else: _on_release(event.position)
	elif event is InputEventMouseMotion and drag_active and drag_visual:
		drag_visual.position = event.position - Vector2(drag_visual.size.x / 2, drag_visual.size.y / 2)

func _on_press(pos: Vector2):
	for i in range(1, 9):
		if _node_hit(shot_nodes[i-1], pos) and not shot_data[i].is_empty():
			_start_drag(shot_data[i]["name"], shot_data[i]["type"], i)
			return
	for i in range(comp_labels.size()):
		if _label_hit(comp_labels[i], pos):
			_start_drag(WEEKLY_CATALOGUE[i][0], WEEKLY_CATALOGUE[i][1], -1)
			return

func _on_release(pos: Vector2):
	if not drag_active: return
	for i in range(1, 9):
		if _node_hit(shot_nodes[i-1], pos):
			_drop_on_shot(i)
			return
	if drag_origin_index > 0 and _node_hit(catalogue, pos):
		_clear_shot(drag_origin_index)
		_end_drag(); _refresh_shots()
		return
	_end_drag()

func _node_hit(node: Node2D, pos: Vector2) -> bool:
	var bg = node.get_node_or_null("Card_Background_Shot")
	if bg == null: bg = node.get_node_or_null("BG_Catalogue")
	if bg == null: return false
	return bg.get_rect().has_point(bg.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if not label.visible: return false
	return label.get_global_rect().has_point(pos)
