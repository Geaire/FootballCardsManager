extends CanvasLayer

const SCENE_COLORS = {
	"res://Scenes/schedule.tscn":           Color(1.0, 0.5,  0.0),
	"res://Scenes/collection_flags.tscn":   Color(0.0, 1.0,  0.0),
	"res://Scenes/collection_country.tscn": Color(0.0, 1.0,  0.0),
	"res://Scenes/competition.tscn":        Color(0.0, 0.75, 1.0),
	"res://Scenes/team.tscn":               Color(0.0, 0.0,  1.0),
	"res://Scenes/bonus.tscn":              Color(1.0, 0.85, 0.0),
	"res://Scenes/transfer.tscn":           Color(0.6, 0.0,  1.0),
	"res://Scenes/association.tscn":        Color(1.0, 1.0,  1.0),
	"res://Scenes/ranking.tscn":            Color(0.9, 0.1,  0.1),
	"res://Scenes/settings.tscn":           Color(0.5, 0.5,  0.5),
	"res://Scenes/main_menu.tscn":          Color(1.0, 1.0,  1.0),
}
const DEFAULT_COLOR = Color(1.0, 1.0, 1.0)

const SCENE_PATHS = {
	"competition": "res://Scenes/competition.tscn",
	"teams":       "",
	"bonus":       "",
	"transfer":    "",
	"settings":    "",
	"schedule":    "res://Scenes/schedule.tscn",
	"history":     "",
	"collection":  "res://Scenes/collection_flags.tscn",
	"association": "",
}

# IMPORTANT : noms exacts des nœuds dans ta scène (minuscule taskbarBottom)
@onready var border_bottom    = $TaskbarBottom/Border_TaskbarBottom
@onready var border_top       = $TaskbarTop/Border_TaskbarTop
@onready var txt_manager_name = $TaskbarTop/TXT_ManagerName
@onready var txt_team_name    = $TaskbarTop/TXT_TeamName
@onready var img_team_logo    = $TaskbarTop/IMG_TeamLogo

@onready var btn_competition = $TaskbarBottom/BTN_Competition
@onready var btn_teams       = $TaskbarBottom/BTN_Team
@onready var btn_bonus       = $TaskbarBottom/BTN_Bonus
@onready var btn_transfer    = $TaskbarBottom/BTN_Transfert
@onready var btn_settings    = $TaskbarBottom/BTN_Settings
@onready var btn_schedule    = $TaskbarBottom/BTN_Schedule
@onready var btn_history     = $TaskbarBottom/BTN_History
@onready var btn_collection  = $TaskbarBottom/BTN_Collection
@onready var btn_association = $TaskbarBottom/BTN_Association

var btn_map: Dictionary = {}

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

func _update_top_bar():
	txt_manager_name.text = GameState.manager_name
	txt_team_name.text    = GameState.team_name
	_load_team_logo()

func _load_team_logo():
	var path = "res://Sprites/Logos/logo_%d.png" % GameState.team_logo_index
	if ResourceLoader.exists(path):
		img_team_logo.texture = load(path)

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

func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var pos = event.position
	for key in btn_map:
		if _sprite_hit(btn_map[key], pos):
			_navigate_to(key)
			return

func _navigate_to(key: String):
	var path = SCENE_PATHS.get(key, "")
	if path == "":
		return
	var current = ""
	if get_tree().current_scene:
		current = get_tree().current_scene.scene_file_path
	if current == path:
		return
	get_tree().change_scene_to_file(path)

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
