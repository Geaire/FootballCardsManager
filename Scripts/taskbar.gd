extends CanvasLayer

const SCENE_COLORS = {
	"res://Scenes/schedule.tscn":           Color(0.0, 0.4, 1.0),
	"res://Scenes/collection_flags.tscn":   Color(0.0, 0.8, 0.2),
	"res://Scenes/collection_country.tscn": Color(0.0, 0.8, 0.2),
	"res://Scenes/detail_card_player.tscn": Color(1.0, 0.85, 0.0),
	"res://Scenes/main_menu.tscn":          Color(1.0, 1.0, 1.0),
}

const DEFAULT_COLOR = Color(1.0, 1.0, 1.0)

const SCENE_PATHS = {
	"competition":  "",
	"team":         "",
	"bonus":        "",
	"transfert":    "",
	"association":  "",
	"schedule":     "res://Scenes/schedule.tscn",
	"collection":   "res://Scenes/collection_flags.tscn",
	"history":      "",
	"settings":     "",
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
var active_btn: Sprite2D = null
var highlight_panel: PanelContainer = null

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

	# Créer UN SEUL PanelContainer pour le highlight
	highlight_panel = PanelContainer.new()
	highlight_panel.size = Vector2(96, 80)
	highlight_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Le mettre DANS le HBoxContainer pour suivre les coordonnées
	var hbox = $TaskbarBottom/BG_TaskbarBottom/HBoxContainer
	hbox.add_child(highlight_panel)
	# Le sortir du flux du HBox en le mettant en position absolue
	highlight_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	highlight_panel.top_level = true
	_hide_highlight()

	_update_border_color()
	get_tree().root.child_entered_tree.connect(_on_scene_changed)

func _hide_highlight():
	if highlight_panel == null: return
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.set_border_width_all(0)
	highlight_panel.add_theme_stylebox_override("panel", style)

func _update_border_color():
	var scene_path = ""
	if get_tree().current_scene:
		scene_path = get_tree().current_scene.scene_file_path
	var col = SCENE_COLORS.get(scene_path, DEFAULT_COLOR)
	_set_border_color(bg_taskbar_bottom, col)
	_set_border_color(bg_taskbar_top, col)
	_update_active_btn(scene_path, col)

func _set_border_color(panel: PanelContainer, col: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.border_color = col
	panel.add_theme_stylebox_override("panel", style)

func _update_active_btn(scene_path: String, col: Color):
	for key in btn_map:
		var btn = btn_map[key]
		if btn:
			btn.modulate = Color(0.55, 0.55, 0.55, 0.65)

	_hide_highlight()

	for key in SCENE_PATHS:
		if SCENE_PATHS[key] == scene_path and btn_map.has(key):
			var btn = btn_map[key]
			if btn:
				btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
				active_btn = btn
				_move_highlight(btn, col)
			break

func _move_highlight(btn: Sprite2D, col: Color):
	if highlight_panel == null: return

	# Positionner le panel sur l'icône active en coordonnées globales
	var btn_global = btn.global_position
	var btn_size = Vector2(96, 80)
	highlight_panel.global_position = btn_global - btn_size / 2.0
	highlight_panel.size = btn_size

	# Style : fond coloré semi-transparent + liséret fin brillant
	var style = StyleBoxFlat.new()
	style.bg_color = Color(col.r, col.g, col.b, 0.12)
	style.border_color = Color(col.r, col.g, col.b, 1.0)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	highlight_panel.add_theme_stylebox_override("panel", style)

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
			_navigate_to(key)
			return

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
