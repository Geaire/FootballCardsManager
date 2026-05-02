extends CanvasLayer

# ── COULEURS BORDURE PAR SCÈNE ────────────────────────────────────────────────
const SCENE_COLORS = {
	"res://Scenes/schedule.tscn":              Color(0.0, 0.4,  1.0),
	"res://Scenes/collection_flags.tscn":      Color(0.0, 0.8,  0.2),
	"res://Scenes/collection_country.tscn":    Color(0.0, 0.8,  0.2),
	"res://Scenes/detail_card_player.tscn":    Color(1.0, 0.85, 0.0),
	"res://Scenes/main_menu.tscn":             Color(1.0, 1.0,  1.0),
}
const DEFAULT_COLOR = Color(1.0, 1.0, 1.0)

# ── SCÈNES ACTIVES ────────────────────────────────────────────────────────────
const SCENE_PATHS = {
	"schedule":    "res://Scenes/schedule.tscn",
	"collection":  "res://Scenes/collection_flags.tscn",
	"competition": "",
	"teams":       "",
	"bonus":       "",
	"transfer":    "",
	"settings":    "",
	"history":     "",
	"association": "",
}

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var border_bottom    = $TaskbarBottom/Border_TaskbarBottom
@onready var border_top       = $TaskbarTop/Border_TaskbarTop
@onready var lbl_manager_name = $TaskbarTop/LBL_ManagerName
@onready var lbl_team_name    = $TaskbarTop/LBL_TeamName
@onready var img_team_logo    = $TaskbarTop/IMG_TeamLogo

@onready var btn_competition = $TaskbarBottom/BTN_Competition
@onready var btn_teams       = $TaskbarBottom/BTN_Teams
@onready var btn_bonus       = $TaskbarBottom/BTN_Bonus
@onready var btn_transfer    = $TaskbarBottom/BTN_Transfer
@onready var btn_settings    = $TaskbarBottom/BTN_Settings
@onready var btn_schedule    = $TaskbarBottom/BTN_Schedule
@onready var btn_history     = $TaskbarBottom/BTN_History
@onready var btn_collection  = $TaskbarBottom/BTN_Collection
@onready var btn_association = $TaskbarBottom/BTN_Association

var btn_map: Dictionary = {}

# ── READY ─────────────────────────────────────────────────────────────────────
func _ready():
	btn_map = {
		"competition": btn_competition,
		"teams":       btn_teams,
		"bonus":       btn_bonus,
		"transfer":    btn_transfer,
		"settings":    btn_settings,
		"schedule":    btn_schedule,
		"history":     btn_history,
		"collection":  btn_collection,
		"association": btn_association,
	}
	_update_top_bar()
	_update_border_color()
	get_tree().root.child_entered_tree.connect(_on_scene_changed)

# ── BARRE DU HAUT ─────────────────────────────────────────────────────────────
func _update_top_bar():
	lbl_manager_name.text = GameState.manager_name
	lbl_team_name.text    = GameState.team_name
	_load_team_logo()

func _load_team_logo():
	var path = "res://Sprites/Logos/logo_%d.png" % GameState.team_logo_index
	if ResourceLoader.exists(path):
		img_team_logo.texture = load(path)

# ── COULEUR BORDURE ───────────────────────────────────────────────────────────
func _update_border_color():
	var scene_path = ""
	if get_tree().current_scene:
		scene_path = get_tree().current_scene.scene_file_path
	var col = SCENE_COLORS.get(scene_path, DEFAULT_COLOR)
	border_bottom.modulate = col
	border_top.modulate    = col

func _on_scene_changed(_node):
	await get_tree().process_frame
	_update_border_color()

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	for key in btn_map:
		if _sprite_hit(btn_map[key], pos):
			_navigate_to(key); return

func _navigate_to(key: String):
	var path = SCENE_PATHS.get(key, "")
	if path == "": return
	var current = ""
	if get_tree().current_scene:
		current = get_tree().current_scene.scene_file_path
	if current == path: return
	get_tree().change_scene_to_file(path)

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
