extends CanvasLayer

const SCENE_COLORS = {
	"res://Scenes/schedule.tscn":           Color(0.0, 0.4,  1.0),
	"res://Scenes/collection_flags.tscn":   Color(0.0, 0.8,  0.2),
	"res://Scenes/collection_country.tscn": Color(0.0, 0.8,  0.2),
	"res://Scenes/detail_card_player.tscn": Color(1.0, 0.85, 0.0),
	"res://Scenes/main_menu.tscn":          Color(1.0, 1.0,  1.0),
}
const DEFAULT_COLOR = Color(1.0, 1.0, 1.0)

const SCENE_PATHS = {
	"competition": "",
	"team":        "",
	"bonus":       "",
	"transfert":   "",
	"association": "",
	"schedule":    "res://Scenes/schedule.tscn",
	"collection":  "res://Scenes/collection_flags.tscn",
	"history":     "",
	"settings":    "",
}

@onready var bg_taskbar_bottom = $TaskbarBottom/BG_TaskbarBottom
@onready var bg_taskbar_top    = $TaskbarTop/BG_TaskbarTop

@onready var btn_competition = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Competition
@onready var btn_team        = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Team
@onready var btn_bonus       = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Bonus
@onready var btn_transfert   = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Transfert
@onready var btn_association = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Association
@onready var btn_schedule    = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Schedule
@onready var btn_collection  = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Collection
@onready var btn_history     = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_History
@onready var btn_settings    = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer/BTN_Settings

var btn_map: Dictionary = {}

func _ready():
	btn_map = {
		"competition": btn_competition,
		"team":        btn_team,
		"bonus":       btn_bonus,
		"transfert":   btn_transfert,
		"association": btn_association,
		"schedule":    btn_schedule,
		"collection":  btn_collection,
		"history":     btn_history,
		"settings":    btn_settings,
	}
	_update_border_color()
	get_tree().root.child_entered_tree.connect(_on_scene_changed)

func _update_border_color():
	var scene_path = ""
	if get_tree().current_scene:
		scene_path = get_tree().current_scene.scene_file_path
	var col = SCENE_COLORS.get(scene_path, DEFAULT_COLOR)
	_set_border_color(bg_taskbar_bottom, col)
	_set_border_color(bg_taskbar_top, col)

func _set_border_color(panel: PanelContainer, col: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.border_color = col
	panel.add_theme_stylebox_override("panel", style)

func _on_scene_changed(_node):
	await get_tree().process_frame
	await get_tree().process_frame
	_update_border_color()

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

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
