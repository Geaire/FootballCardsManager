extends Node2D

const SCENE_COLLECTION_COUNTRY = "res://Scenes/collection_country.tscn"
const SLIDE_DURATION            = 0.35
const MAX_CONDITIONS            = 17

const PAGE1_COUNTRIES = [
	"AE","AO","AR","AT","AU","BA","BE","BG","BO","BR",
	"CA","CD","CH","CI","CL","CM","CN","CO","CR","CU",
	"CZ","DE","DK","DZ","EC","EG","ES","FR","GB","GH",
	"GR","HN","HR","HT","HU","ID","IE","IL","IQ","IR"
]
const PAGE2_COUNTRIES = [
	"IT","JM","JP","KP","KR","KW","MA","MX","NG","NI",
	"NL","NO","NZ","PA","PE","PL","PT","PY","QA","RO",
	"RS","RU","SA","SC","SE","SI","SK","SN","SV","TG",
	"TN","TR","TT","UA","US","UY","WA","ZA"
]

var current_page: int = 1
var is_animating: bool = false
var country_progress: Dictionary = {}
var flag_decorations: Dictionary = {}

var page1: Node2D
var page2: Node2D
var btn_next_page: Sprite2D
var btn_prev_page: Sprite2D

func _ready():
	page1         = get_node("Page1")
	page2         = get_node("Page2")
	btn_next_page = get_node("Page1/BTN_NextPage")
	btn_prev_page = get_node("Page2/BTN_PrevPage")
	page2.position.y = 1080.0
	_apply_default_styles()
	_create_decorations()
	_load_progress()

func _apply_default_styles():
	for code in PAGE1_COUNTRIES:
		var node = page1.get_node_or_null(code)
		if node:
			var txt = node.get_node_or_null("TXT_" + code)
			if txt:
				txt.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.5))
	for code in PAGE2_COUNTRIES:
		var node = page2.get_node_or_null(code)
		if node:
			var txt = node.get_node_or_null("TXT_" + code)
			if txt:
				txt.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.5))

func _create_decorations():
	for code in PAGE1_COUNTRIES:
		_create_deco_for(code, page1)
	for code in PAGE2_COUNTRIES:
		_create_deco_for(code, page2)

func _create_deco_for(code: String, page_node: Node):
	var country_node = page_node.get_node_or_null(code)
	if not country_node: return
	var flag = country_node.get_node_or_null("Flag_" + code)
	var txt  = country_node.get_node_or_null("TXT_" + code)
	if not flag or not txt: return

	var fx = flag.position.x
	var fy = flag.position.y

	var bar_y = fy + 41
	txt.position.y = fy + 50

	# Rectangle encadré
	var panel = PanelContainer.new()
	panel.size = Vector2(128, 88)
	panel.position = Vector2(fx - 64, fy - 44)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = -1
	panel.visible = false
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style.border_color = Color(0.2, 0.85, 0.3, 0.7)
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	country_node.add_child(panel)

	# Fond vert 50% — toute la largeur, toujours visible
	var bar_bg = ColorRect.new()
	bar_bg.size = Vector2(120, 8)
	bar_bg.position = Vector2(fx - 60, bar_y)
	bar_bg.color = Color(0.2, 0.85, 0.3, 0.5)
	bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar_bg.z_index = 2
	bar_bg.visible = true
	country_node.add_child(bar_bg)

	# Remplissage vert 100% — progresse selon les conditions
	var bar_fill = ColorRect.new()
	bar_fill.size = Vector2(0, 8)
	bar_fill.position = Vector2(fx - 60, bar_y)
	bar_fill.color = Color(0.2, 0.9, 0.3, 1.0)
	bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar_fill.z_index = 3
	bar_fill.visible = true
	country_node.add_child(bar_fill)

	# Point vert 17/17
	var dot = Label.new()
	dot.text = "●"
	dot.position = Vector2(fx + 42, fy - 50)
	dot.z_index = 5
	dot.visible = false
	dot.add_theme_color_override("font_color", Color(0.2, 0.9, 0.3))
	dot.add_theme_font_size_override("font_size", 14)
	country_node.add_child(dot)

	flag_decorations[code] = {
		"panel":    panel,
		"bar_bg":   bar_bg,
		"bar_fill": bar_fill,
		"dot":      dot,
	}

func _load_progress():
	Firebase.firestore_success.connect(_on_progress_loaded)
	Firebase.firestore_failed.connect(_on_progress_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/collection", "progress")

func _on_progress_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_progress_loaded):
		Firebase.firestore_success.disconnect(_on_progress_loaded)
	if Firebase.firestore_failed.is_connected(_on_progress_failed):
		Firebase.firestore_failed.disconnect(_on_progress_failed)
	for code in PAGE1_COUNTRIES + PAGE2_COUNTRIES:
		country_progress[code] = int(data.get(code, 0))
	_update_counters()

func _on_progress_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_progress_loaded):
		Firebase.firestore_success.disconnect(_on_progress_loaded)
	if Firebase.firestore_failed.is_connected(_on_progress_failed):
		Firebase.firestore_failed.disconnect(_on_progress_failed)
	_update_counters()

func _update_counters():
	for code in PAGE1_COUNTRIES:
		_style_flag(code, page1)
	for code in PAGE2_COUNTRIES:
		_style_flag(code, page2)

func _style_flag(code: String, page_node: Node):
	var progress    = country_progress.get(code, 0)
	var is_complete = progress == MAX_CONDITIONS
	var is_empty    = progress == 0

	var country_node = page_node.get_node_or_null(code)
	if country_node:
		var flag = country_node.get_node_or_null("Flag_" + code)
		if flag:
			flag.modulate = Color(1.0, 1.0, 1.0, 1.0)

		var txt = country_node.get_node_or_null("TXT_" + code)
		if txt:
			txt.text = str(progress) + "/" + str(MAX_CONDITIONS)
			if is_complete:
				txt.add_theme_color_override("font_color", Color(0.2, 0.9, 0.3))
			elif is_empty:
				txt.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.5))
			else:
				txt.add_theme_color_override("font_color", Color(0.7, 0.85, 0.7, 0.85))

	var deco = flag_decorations.get(code, null)
	if not deco: return

	# Rectangle visible si au moins 1 condition
	deco["panel"].visible = not is_empty

	# Fond vert 50% — toujours visible
	deco["bar_bg"].visible = true

	# Remplissage vert 100% — width selon progression
	deco["bar_fill"].visible = true
	var fill_w = (float(progress) / MAX_CONDITIONS) * 120.0
	deco["bar_fill"].size = Vector2(fill_w, 8)

	# Point vert uniquement si 17/17
	deco["dot"].visible = is_complete

func _animate_to_page(page: int):
	if is_animating: return
	is_animating = true; current_page = page
	var tween = create_tween(); tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT); tween.set_trans(Tween.TRANS_CUBIC)
	if page == 2:
		tween.tween_property(page1, "position:y", -1080.0, SLIDE_DURATION)
		tween.tween_property(page2, "position:y", 0.0,     SLIDE_DURATION)
	else:
		tween.tween_property(page1, "position:y", 0.0,    SLIDE_DURATION)
		tween.tween_property(page2, "position:y", 1080.0, SLIDE_DURATION)
	tween.chain().tween_callback(func(): is_animating = false)

func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if _sprite_hit(btn_next_page, pos) and current_page == 1:
		_animate_to_page(2); return
	if _sprite_hit(btn_prev_page, pos) and current_page == 2:
		_animate_to_page(1); return
	var countries = PAGE1_COUNTRIES if current_page == 1 else PAGE2_COUNTRIES
	var page_node = page1 if current_page == 1 else page2
	for code in countries:
		var flag = page_node.get_node_or_null(code + "/Flag_" + code)
		if flag and _sprite_hit(flag, pos):
			GameState.selected_country  = code
			GameState.previous_scene    = "res://Scenes/collection_flags.tscn"
			get_tree().change_scene_to_file(SCENE_COLLECTION_COUNTRY)
			return

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
